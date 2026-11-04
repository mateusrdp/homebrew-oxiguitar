cask "oxiguitar-eq" do
  version "0.1.0"
  sha256 "425de9ea6dda68784b01528c25330600059a41f7e2bda6f117462ba27814f6c4"

  url "https://github.com/mateusrdp/oxiguitar-eq/releases/download/v#{version}/oxiguitar-eq-#{version}-macos-universal.zip"
  name "OxiGuitar plugin: eq"
  desc "Equalizer for OxiGuitar"
  homepage "https://github.com/mateusrdp/oxiguitar-eq"

  artifact "eq-0.1.0-macos-universal.oxp", target: "~/Library/Application Support/OxiGuitar/plugins/eq-0.1.0-macos-universal.oxp"

  # The plugin is ad-hoc signed, not notarized (no Apple certificate is paid
  # for), so the mark the download leaves on it is taken off.
  postflight do
    [
      "#{Dir.home}/Library/Application Support/OxiGuitar/plugins/eq-0.1.0-macos-universal.oxp",
    ].each do |path|
      system_command "/usr/bin/xattr", args: ["-d", "com.apple.quarantine", path], must_succeed: false
    end
  end

  zap trash: "~/Library/Application Support/OxiGuitar/plugins/eq-0.1.0-macos-universal.oxp"
end
