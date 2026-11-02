cask "oxiguitar-coreaudio" do
  version "0.1.0"
  sha256 "4f657ecf38f578da037797b24f3ea2d22f54cb4905a90ea1a175833763019c0d"

  url "https://github.com/mateusrdp/oxiguitar-coreaudio/releases/download/v#{version}/oxiguitar-coreaudio-#{version}-macos-universal.zip"
  name "OxiGuitar plugin: coreaudio"
  desc "OxiGuitar's Core Audio output plugin"
  homepage "https://github.com/mateusrdp/oxiguitar-coreaudio"

  artifact "audio-coreaudio-0.1.0-macos-universal.oxp", target: "~/Library/Application Support/OxiGuitar/plugins/audio-coreaudio-0.1.0-macos-universal.oxp"

  # The plugin is ad-hoc signed, not notarized (no Apple certificate is paid
  # for), so the mark the download leaves on it is taken off.
  postflight do
    [
      "#{Dir.home}/Library/Application Support/OxiGuitar/plugins/audio-coreaudio-0.1.0-macos-universal.oxp",
    ].each do |path|
      system_command "/usr/bin/xattr",
                     args: ["-d", "com.apple.quarantine", path],
                     must_succeed: false
    end
  end

  zap trash: [
    "~/Library/Application Support/OxiGuitar/plugins/audio-coreaudio-0.1.0-macos-universal.oxp",
  ]
end
