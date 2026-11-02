cask "oxiguitar-nam" do
  version "0.1.0"
  sha256 "b4b47b556ac561d9142042acc4b4d6f291f60ee9de0a94516236db64bfa3ff2f"

  url "https://github.com/mateusrdp/oxiguitar-nam/releases/download/v#{version}/oxiguitar-nam-#{version}-macos-universal.zip"
  name "OxiGuitar plugin: nam"
  desc "OxiGuitar's amp model (NAM) plugin"
  homepage "https://github.com/mateusrdp/oxiguitar-nam"

  depends_on cask: "mateusrdp/oxiguitar/oxiguitar-midi"

  artifact "nam-0.1.0-macos-universal.oxp", target: "~/Library/Application Support/OxiGuitar/plugins/nam-0.1.0-macos-universal.oxp"

  # The plugin is ad-hoc signed, not notarized (no Apple certificate is paid
  # for), so the mark the download leaves on it is taken off.
  postflight do
    [
      "#{Dir.home}/Library/Application Support/OxiGuitar/plugins/nam-0.1.0-macos-universal.oxp",
    ].each do |path|
      system_command "/usr/bin/xattr",
                     args: ["-d", "com.apple.quarantine", path],
                     must_succeed: false
    end
  end

  zap trash: [
    "~/Library/Application Support/OxiGuitar/plugins/nam-0.1.0-macos-universal.oxp",
  ]
end
