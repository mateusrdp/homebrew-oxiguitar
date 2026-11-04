cask "oxiguitar" do
  version "0.13.0"
  sha256 "13bcfba937f4f7b33d53c001dff894bf45f7307d8bff325eb0ed7a2f9eb9436f"

  url "https://github.com/mateusrdp/oxiguitar/releases/download/v#{version}/OxiGuitar-#{version}-macos-universal.dmg"
  name "OxiGuitar"
  desc "Guitar tablature and score viewer, editor and player, written in Rust"
  homepage "https://github.com/mateusrdp/oxiguitar"

  depends_on :macos
  depends_on cask: "mateusrdp/oxiguitar/oxiguitar-guitarpro"
  depends_on cask: "mateusrdp/oxiguitar/oxiguitar-midi"

  app "OxiGuitar.app"

  zap trash: [
    "~/Library/Application Support/OxiGuitar",
    "~/Library/Caches/OxiGuitar",
  ]

  caveats <<~EOS
    Suggested plugins, each a cask of its own:
      brew install --cask mateusrdp/oxiguitar/oxiguitar-nam mateusrdp/oxiguitar/oxiguitar-eq
  EOS
end
