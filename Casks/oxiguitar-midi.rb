cask "oxiguitar-midi" do
  version "0.1.0"
  sha256 "0c65a4de31d014aff65bcfd2e09bb1e19d9d7e5453e9ceeade98f6d7007d1ecb"

  url "https://github.com/mateusrdp/oxiguitar-midi/releases/download/v#{version}/oxiguitar-midi-#{version}-macos-universal.zip"
  name "OxiGuitar plugin: midi"
  desc "OxiGuitar's MIDI plugin: SoundFont and SFZ sound sets"
  homepage "https://github.com/mateusrdp/oxiguitar-midi"

  artifact "midi-0.1.0-macos-universal.oxp", target: "~/Library/Application Support/OxiGuitar/plugins/midi-0.1.0-macos-universal.oxp"

  # The plugin is ad-hoc signed, not notarized (no Apple certificate is paid
  # for), so the mark the download leaves on it is taken off.
  postflight do # rubocop:disable Cask/InstallSteps
    [
      "#{Dir.home}/Library/Application Support/OxiGuitar/plugins/midi-0.1.0-macos-universal.oxp",
    ].each do |path|
      system_command "/usr/bin/xattr", args: ["-d", "com.apple.quarantine", path], must_succeed: false
    end
  end

  zap trash: "~/Library/Application Support/OxiGuitar/plugins/midi-0.1.0-macos-universal.oxp"
end
