cask "oxiguitar-midi" do
  version "0.2.2"
  sha256 "35bd21d42a25745fd47c285869e10fdb5ba76441b533f5a033c63fcd9128d816"

  url "https://github.com/mateusrdp/oxiguitar-midi/releases/download/v#{version}/oxiguitar-midi-#{version}-macos-universal.zip"
  name "OxiGuitar plugin: midi"
  desc "OxiGuitar's MIDI plugin: SoundFont and SFZ sound sets"
  homepage "https://github.com/mateusrdp/oxiguitar-midi"

  artifact "midi-0.2.2-macos-universal.oxp", target: "~/Library/Application Support/OxiGuitar/plugins/midi-0.2.2-macos-universal.oxp"

  # The plugin is ad-hoc signed, not notarized (no Apple certificate is paid
  # for), so the mark the download leaves on it is taken off.
  postflight do
    [
      "#{Dir.home}/Library/Application Support/OxiGuitar/plugins/midi-0.2.2-macos-universal.oxp",
    ].each do |path|
      system_command "/usr/bin/xattr", args: ["-d", "com.apple.quarantine", path], must_succeed: false
    end
  end

  zap trash: "~/Library/Application Support/OxiGuitar/plugins/midi-0.2.2-macos-universal.oxp"
end
