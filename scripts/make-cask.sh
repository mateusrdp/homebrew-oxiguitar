#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C) 2026 Mateus Rocha de Paula and the OxiGuitar contributors
#
# Writes the cask of one OxiGuitar repository's release into Casks/, from the
# release's macOS file and its SHA256SUMS:
#   - the core (mateusrdp/oxiguitar): OxiGuitar-VERSION-macos-universal.dmg,
#     cask "oxiguitar", which installs OxiGuitar.app and depends on the
#     essential plugins (CORE_DEPENDS, default "oxiguitar-guitarpro oxiguitar-midi")
#     and suggests others in its caveats (CORE_SUGGESTS, default
#     "oxiguitar-nam oxiguitar-eq", as the .deb and .rpm suggest them; casks
#     have no "suggests" of their own);
#   - a plugin (any other repository): oxiguitar-NAME-VERSION-macos-universal.zip,
#     cask "oxiguitar-NAME", which puts each .oxp of the zip in
#     ~/Library/Application Support/OxiGuitar/plugins and takes the quarantine
#     mark off it (no Apple certificate is ever paid for, Mateus 1 Nov 2026).
#     PLUGIN_DEPENDS="oxiguitar-midi" adds dependencies on other casks.
# A release without a macOS file leaves no cask and says so.
#
# Usage: scripts/make-cask.sh REPOSITORY TAG
#   REPOSITORY  owner/name, such as mateusrdp/oxiguitar-midi
# Needs gh (GH_TOKEN, to read the release's file list), curl, unzip.
set -euo pipefail
trap 'echo "::error::make-cask.sh line $LINENO: $BASH_COMMAND"' ERR

repo="${1:?usage: make-cask.sh REPOSITORY TAG}"
tag="${2:?}"
version="${tag#v}"
here="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p "$here/Casks"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

assets="$(gh api "repos/$repo/releases/tags/$tag" --jq '.assets[].name')"
description="$(gh api "repos/$repo" --jq '.description // ""')"
description="${description%.}"
# Cask descriptions mustn't start with an article or end with a full stop,
# and mustn't contain a double quote.
description="${description//\"/\'}"

# Public releases need no token; curl also works where gh's release download
# (which uses GraphQL) doesn't.
download() {
    curl -fsSL --retry 5 -o "$tmp/$1" "https://github.com/$repo/releases/download/$tag/$1"
}

sum_of() {
    awk -v n="$1" '$2 == n || $2 == "*" n { print $1 }' "$tmp/SHA256SUMS"
}

if [[ "$repo" == "mateusrdp/oxiguitar" ]]; then
    file="OxiGuitar-$version-macos-universal.dmg"
    if ! grep -qxF "$file" <<< "$assets"; then
        echo "::notice::$repo $tag has no $file: no cask."
        exit 0
    fi
    download SHA256SUMS
    sum="$(sum_of "$file")"
    [[ -n "$sum" ]] || { echo "::error::$file is not in SHA256SUMS"; exit 1; }
    # brew style (Homebrew/OSDependsOn) wants a cask with an app to say it is macOS-only.
    depends="  depends_on :macos"$'\n'
    for c in ${CORE_DEPENDS-oxiguitar-guitarpro oxiguitar-midi}; do
        depends+="  depends_on cask: \"mateusrdp/oxiguitar/$c\""$'\n'
    done
    suggests=""
    for c in ${CORE_SUGGESTS-oxiguitar-nam oxiguitar-eq}; do
        suggests+=" mateusrdp/oxiguitar/$c"
    done
    caveats=""
    if [[ -n "$suggests" ]]; then
        # Casks put caveats last, after zap.
        caveats=$'\n\n'"  caveats <<~EOS
    Suggested plugins, each a cask of its own:
      brew install --cask$suggests
  EOS"
    fi
    cat > "$here/Casks/oxiguitar.rb" <<CASK
cask "oxiguitar" do
  version "$version"
  sha256 "$sum"

  url "https://github.com/$repo/releases/download/v#{version}/OxiGuitar-#{version}-macos-universal.dmg"
  name "OxiGuitar"
  desc "${description:-Guitar tablature viewer, editor and player}"
  homepage "https://github.com/$repo"

$depends
  app "OxiGuitar.app"

  zap trash: [
    "~/Library/Application Support/OxiGuitar",
    "~/Library/Caches/OxiGuitar",
  ]$caveats
end
CASK
    echo "Casks/oxiguitar.rb: $version"
    exit 0
fi

zip="$(grep -E '^oxiguitar-.+-macos-universal\.zip$' <<< "$assets" | head -n 1 || true)"
if [[ -z "$zip" ]]; then
    echo "::notice::$repo $tag has no macOS zip: no cask."
    exit 0
fi
name="${zip#oxiguitar-}"
name="${name%-"$version"-macos-universal.zip}"
cask="oxiguitar-${repo#mateusrdp/oxiguitar-}"
download SHA256SUMS
download "$zip"
sum="$(sum_of "$zip")"
[[ -n "$sum" ]] || { echo "::error::$zip is not in SHA256SUMS"; exit 1; }
[[ "$sum" == "$(sha256sum "$tmp/$zip" | cut -d' ' -f1)" ]] || { echo "::error::$zip does not match SHA256SUMS"; exit 1; }

files="$(unzip -Z1 "$tmp/$zip" | grep -E '\.oxp$')"
[[ -n "$files" ]] || { echo "::error::$zip holds no .oxp file"; exit 1; }
artifacts=""
trash=""
paths=""
while read -r f; do
    artifacts+="  artifact \"$f\", target: \"~/Library/Application Support/OxiGuitar/plugins/$f\""$'\n'
    trash+="    \"~/Library/Application Support/OxiGuitar/plugins/$f\","$'\n'
    first_trash="${first_trash:-~/Library/Application Support/OxiGuitar/plugins/$f}"
    paths+="      \"#{Dir.home}/Library/Application Support/OxiGuitar/plugins/$f\","$'\n'
done <<< "$files"
# Homebrew's style wants a single path bare and several in an array.
if [[ "$(wc -l <<< "$files")" -eq 1 ]]; then
    trash="\"$first_trash\""
else
    trash="["$'\n'"$trash  ]"
fi
depends=""
for c in ${PLUGIN_DEPENDS-}; do
    depends+="  depends_on cask: \"mateusrdp/oxiguitar/$c\""$'\n'
done
[[ -n "$depends" ]] && depends+=$'\n'

cat > "$here/Casks/$cask.rb" <<CASK
cask "$cask" do
  version "$version"
  sha256 "$sum"

  url "https://github.com/$repo/releases/download/v#{version}/oxiguitar-$name-#{version}-macos-universal.zip"
  name "OxiGuitar plugin: $name"
  desc "${description:-A plugin for OxiGuitar}"
  homepage "https://github.com/$repo"

${depends}${artifacts}
  # The plugin is ad-hoc signed, not notarized (no Apple certificate is paid
  # for), so the mark the download leaves on it is taken off.
  postflight do
    [
${paths}    ].each do |path|
      system_command "/usr/bin/xattr", args: ["-d", "com.apple.quarantine", path], must_succeed: false
    end
  end

  zap trash: ${trash}
end
CASK
echo "Casks/$cask.rb: $version ($(wc -l <<< "$files") plugin file(s))"
