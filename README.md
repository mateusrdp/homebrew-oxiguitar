# homebrew-oxiguitar

Homebrew tap for OxiGuitar and its plugins

Part of [OxiGuitar](https://github.com/mateusrdp/oxiguitar), a free, open-source
guitar tablature and score viewer, editor and player for Windows, macOS and
Linux. The user manual and the plugin developer guide live in the
[OxiGuitar repository](https://github.com/mateusrdp/oxiguitar).

## Using the tap

```sh
brew tap mateusrdp/oxiguitar
brew install --cask oxiguitar
```

`oxiguitar` brings the essential plugins (`oxiguitar-guitarpro` and
`oxiguitar-midi`) and suggests, in what `brew` prints after installing it,
`oxiguitar-nam` (amp models) and `oxiguitar-eq` (an equalizer). The others are
casks of the same name pattern, such as `oxiguitar-wav` or
`oxiguitar-coreaudio`; `brew upgrade` keeps all of them current.

A plugin cask puts the plugin's file in
`~/Library/Application Support/OxiGuitar/plugins` and takes off the quarantine
mark the download leaves on it. Nothing is signed with an Apple certificate
(none is paid for), so macOS may ask you to allow OxiGuitar once under System
Settings, Privacy and Security, "Open Anyway".

## How it works

Casks are made, not written. When a repository's release is published, its
publish workflow sends the event `plugin-published` here (secret
`PACKAGES_TOKEN` over there), `update.yml` runs `scripts/make-cask.sh`, which
reads the release's macOS file and `SHA256SUMS`, and opens a pull request
with the new cask; merging it updates the tap. `update.yml` can also be run by
hand with a repository and a tag. It needs the secret `PACKAGES_TOKEN` here
too, a token of the maintainer's with contents and pull-request write access
to this repository (a pull request made with the built-in token starts no CI
and cannot be merged).

CI installs every cask on macOS and checks that no plugin it installed is
still quarantined.

## Licence

GPL-3.0-or-later. See LICENSE.
Contributions are welcome under the same terms; see
[CONTRIBUTING.md](CONTRIBUTING.md).
