cask "oxiguitar-midi" do
  version "0.2.0"
  sha256 "70dc8c1a8d5c4dc5361e05a75c1d10b5d657b5e4e03a63ef13ae7bfed94b2011"

  url "https://github.com/mateusrdp/oxiguitar-midi/releases/download/v#{version}/oxiguitar-midi-#{version}-macos-universal.zip"
  name "OxiGuitar plugin: midi"
  desc "OxiGuitar's MIDI plugin: SoundFont and SFZ sound sets"
  homepage "https://github.com/mateusrdp/oxiguitar-midi"

  artifact "midi-0.2.0-macos-universal.oxp", target: "~/Library/Application Support/OxiGuitar/plugins/midi-0.2.0-macos-universal.oxp"

  # The plugin is ad-hoc signed, not notarized (no Apple certificate is paid
  # for), so the mark the download leaves on it is taken off.
  postflight do
    [
      "#{Dir.home}/Library/Application Support/OxiGuitar/plugins/midi-0.2.0-macos-universal.oxp",
    ].each do |path|
      system_command "/usr/bin/xattr", args: ["-d", "com.apple.quarantine", path], must_succeed: false
    end
  end

  zap trash: "~/Library/Application Support/OxiGuitar/plugins/midi-0.2.0-macos-universal.oxp"
end
