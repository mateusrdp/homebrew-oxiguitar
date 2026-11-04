cask "oxiguitar-nam" do
  version "0.2.0"
  sha256 "0082396bb23e05f19aef164d328c06797b34df871c3f0663ba487a8309648082"

  url "https://github.com/mateusrdp/oxiguitar-nam/releases/download/v#{version}/oxiguitar-nam-#{version}-macos-universal.zip"
  name "OxiGuitar plugin: nam"
  desc "OxiGuitar's amp model (NAM) plugin"
  homepage "https://github.com/mateusrdp/oxiguitar-nam"

  depends_on cask: "mateusrdp/oxiguitar/oxiguitar-midi"

  artifact "nam-0.2.0-macos-universal.oxp", target: "~/Library/Application Support/OxiGuitar/plugins/nam-0.2.0-macos-universal.oxp"

  # The plugin is ad-hoc signed, not notarized (no Apple certificate is paid
  # for), so the mark the download leaves on it is taken off.
  postflight do
    [
      "#{Dir.home}/Library/Application Support/OxiGuitar/plugins/nam-0.2.0-macos-universal.oxp",
    ].each do |path|
      system_command "/usr/bin/xattr", args: ["-d", "com.apple.quarantine", path], must_succeed: false
    end
  end

  zap trash: "~/Library/Application Support/OxiGuitar/plugins/nam-0.2.0-macos-universal.oxp"
end
