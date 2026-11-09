cask "tex-messages" do
  version "0.1.1"
  sha256 "052b1d56906df04cfbd2971ae2f57cfc576f9a8b54888c45a8bb005c8045172d"

  url "https://github.com/deancureton/tex-messages/archive/refs/tags/v#{version}.tar.gz"
  name "TeX Messages"
  desc "IMessage client that renders LaTeX in your bubbles"
  homepage "https://github.com/deancureton/tex-messages"

  depends_on macos: :tahoe

  app "TeX Messages.app"

  preflight do
    source = staged_path/"tex-messages-#{version}"
    system_command "/usr/bin/swift",
                   args:         ["build", "--disable-sandbox", "-c", "release", "--package-path", source.to_s],
                   print_stderr: false,
                   must_succeed: true
    contents = staged_path/"TeX Messages.app/Contents"
    FileUtils.mkdir_p [contents/"MacOS", contents/"Resources"]
    FileUtils.cp source/".build/release/TeXMessages", contents/"MacOS/TeXMessages"
    (contents/"Resources/mathjax.js").binwrite((source/"Resources/mathjax.js").binread)
    (contents/"Resources/AppIcon.icns").binwrite((source/"Resources/AppIcon.icns").binread)
    (contents/"Info.plist").binwrite((source/"Resources/Info.plist").binread)
    system_command "/usr/bin/codesign",
                   args:         ["--force", "--deep", "--sign", "-", (staged_path/"TeX Messages.app").to_s],
                   print_stderr: false,
                   must_succeed: true
  end

  zap trash: [
    "~/Library/Application Support/TeX Messages",
    "~/Library/Preferences/com.deancureton.texmessages.plist",
  ]

  caveats <<~EOS
    TeX Messages needs Full Disk Access to read your messages.
    Until notarized builds ship, you may need to grant it again after upgrades.
  EOS
end
