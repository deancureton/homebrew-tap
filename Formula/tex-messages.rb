class TexMessages < Formula
  desc "IMessage client for macOS that renders LaTeX in your bubbles"
  homepage "https://github.com/deancureton/tex-messages"
  url "https://github.com/deancureton/tex-messages.git", tag: "v0.1.0"
  head "https://github.com/deancureton/tex-messages.git", branch: "main"

  depends_on macos: :tahoe

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    contents = prefix/"TeX Messages.app/Contents"
    (contents/"MacOS").install ".build/release/TeXMessages"
    (contents/"Resources").install "Resources/mathjax.js", "Resources/AppIcon.icns"
    contents.install "Resources/Info.plist"
    system "codesign", "--force", "--deep", "--sign", "-", prefix/"TeX Messages.app"
    (bin/"tex-messages").write <<~SH
      #!/bin/sh
      exec open "#{opt_prefix}/TeX Messages.app"
    SH
  end

  def caveats
    <<~EOS
      Add it to Applications:
        ln -sf "#{opt_prefix}/TeX Messages.app" /Applications/

      It needs Full Disk Access to read your messages. Because the build is
      ad-hoc signed, you will need to grant it again after each upgrade.
    EOS
  end

  test do
    assert_path_exists prefix/"TeX Messages.app/Contents/MacOS/TeXMessages"
    system "codesign", "--verify", prefix/"TeX Messages.app"
  end
end
