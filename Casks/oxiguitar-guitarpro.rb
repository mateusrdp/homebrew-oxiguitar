cask "oxiguitar-guitarpro" do
  version "0.1.0"
  sha256 "d6b08f47a1940f97e5a4775303ea25447412de18cedf0d9f38e9f6af5170a433"

  url "https://github.com/mateusrdp/oxiguitar-guitarpro/releases/download/v#{version}/oxiguitar-guitarpro-#{version}-macos-universal.zip"
  name "OxiGuitar plugin: guitarpro"
  desc "Guitar Pro 3, 4, 5, 6 and 7-8 format plugins for OxiGuitar"
  homepage "https://github.com/mateusrdp/oxiguitar-guitarpro"

  artifact "gp-0.1.0-macos-universal.oxp", target: "~/Library/Application Support/OxiGuitar/plugins/gp-0.1.0-macos-universal.oxp"
  artifact "gp3-0.1.0-macos-universal.oxp", target: "~/Library/Application Support/OxiGuitar/plugins/gp3-0.1.0-macos-universal.oxp"
  artifact "gp4-0.1.0-macos-universal.oxp", target: "~/Library/Application Support/OxiGuitar/plugins/gp4-0.1.0-macos-universal.oxp"
  artifact "gp5-0.1.0-macos-universal.oxp", target: "~/Library/Application Support/OxiGuitar/plugins/gp5-0.1.0-macos-universal.oxp"
  artifact "gpx-0.1.0-macos-universal.oxp", target: "~/Library/Application Support/OxiGuitar/plugins/gpx-0.1.0-macos-universal.oxp"

  # The plugin is ad-hoc signed, not notarized (no Apple certificate is paid
  # for), so the mark the download leaves on it is taken off.
  postflight do
    [
      "#{Dir.home}/Library/Application Support/OxiGuitar/plugins/gp-0.1.0-macos-universal.oxp",
      "#{Dir.home}/Library/Application Support/OxiGuitar/plugins/gp3-0.1.0-macos-universal.oxp",
      "#{Dir.home}/Library/Application Support/OxiGuitar/plugins/gp4-0.1.0-macos-universal.oxp",
      "#{Dir.home}/Library/Application Support/OxiGuitar/plugins/gp5-0.1.0-macos-universal.oxp",
      "#{Dir.home}/Library/Application Support/OxiGuitar/plugins/gpx-0.1.0-macos-universal.oxp",
    ].each do |path|
      system_command "/usr/bin/xattr",
                     args: ["-d", "com.apple.quarantine", path],
                     must_succeed: false
    end
  end

  zap trash: [
    "~/Library/Application Support/OxiGuitar/plugins/gp-0.1.0-macos-universal.oxp",
    "~/Library/Application Support/OxiGuitar/plugins/gp3-0.1.0-macos-universal.oxp",
    "~/Library/Application Support/OxiGuitar/plugins/gp4-0.1.0-macos-universal.oxp",
    "~/Library/Application Support/OxiGuitar/plugins/gp5-0.1.0-macos-universal.oxp",
    "~/Library/Application Support/OxiGuitar/plugins/gpx-0.1.0-macos-universal.oxp",
  ]
end
