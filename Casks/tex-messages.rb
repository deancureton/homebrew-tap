cask "tex-messages" do
  version "0.2.0"
  sha256 "46dfebede3d8fdbe55424cdb3d06a6b6a0d113b681e2f5d212583b6ec9ef1e5c"

  url "https://github.com/deancureton/tex-messages/releases/download/v#{version}/TeXMessages-#{version}.zip"
  name "TeX Messages"
  desc "IMessage client that renders LaTeX in your bubbles"
  homepage "https://github.com/deancureton/tex-messages"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :tahoe

  app "TeX Messages.app"

  zap trash: [
    "~/Library/Application Support/TeX Messages",
    "~/Library/Preferences/com.deancureton.texmessages.plist",
  ]

  caveats <<~EOS
    TeX Messages needs Full Disk Access to read your messages.
  EOS
end
