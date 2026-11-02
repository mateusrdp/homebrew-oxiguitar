cask "oxiguitar-wav" do
  version "0.1.0"
  sha256 "4bbfbda17024410f9e37a25062755b30a6275fe2e75fb4ebaf5e93c58788f7bd"

  url "https://github.com/mateusrdp/oxiguitar-wav/releases/download/v#{version}/oxiguitar-wav-#{version}-macos-universal.zip"
  name "OxiGuitar plugin: wav"
  desc "OxiGuitar's WAV export plugin"
  homepage "https://github.com/mateusrdp/oxiguitar-wav"

  artifact "wav-0.1.0-macos-universal.oxp", target: "~/Library/Application Support/OxiGuitar/plugins/wav-0.1.0-macos-universal.oxp"

  # The plugin is ad-hoc signed, not notarized (no Apple certificate is paid
  # for), so the mark the download leaves on it is taken off.
  postflight do
    [
      "#{Dir.home}/Library/Application Support/OxiGuitar/plugins/wav-0.1.0-macos-universal.oxp",
    ].each do |path|
      system_command "/usr/bin/xattr",
                     args: ["-d", "com.apple.quarantine", path],
                     must_succeed: false
    end
  end

  zap trash: [
    "~/Library/Application Support/OxiGuitar/plugins/wav-0.1.0-macos-universal.oxp",
  ]
end
