cask "tex-messages" do
  version "0.1.1"
  sha256 "052b1d56906df04cfbd2971ae2f57cfc576f9a8b54888c45a8bb005c8045172d"

  url "https://github.com/deancureton/tex-messages/archive/refs/tags/v#{version}.tar.gz"
  name "TeX Messages"
  desc "IMessage client that renders LaTeX in your bubbles"
  homepage "https://github.com/deancureton/tex-messages"

  depends_on macos: :tahoe

  app "TeX Messages.app"

  preflight_steps do
    mkdir_p "{{temp}}/home", base: :temp
    run "/usr/bin/swift",
        args:         ["build", "--disable-sandbox", "-c", "release",
                       "--package-path", "{{staged_path}}/tex-messages-{{version}}",
                       "--cache-path", "{{temp}}/swiftpm-cache",
                       "--config-path", "{{temp}}/swiftpm-config",
                       "--security-path", "{{temp}}/swiftpm-security"],
        env:          { "HOME" => "{{temp}}/home", "CLANG_MODULE_CACHE_PATH" => "{{temp}}/module-cache" },
        print_stderr: false
    mkdir_p "TeX Messages.app/Contents/MacOS"
    mkdir_p "TeX Messages.app/Contents/Resources"
    copy "tex-messages-{{version}}/.build/release/TeXMessages", "TeX Messages.app/Contents/MacOS/TeXMessages"
    run "/bin/cat",
        args:        ["{{staged_path}}/tex-messages-{{version}}/Resources/mathjax.js"],
        stdout_path: "TeX Messages.app/Contents/Resources/mathjax.js"
    run "/bin/cat",
        args:        ["{{staged_path}}/tex-messages-{{version}}/Resources/AppIcon.icns"],
        stdout_path: "TeX Messages.app/Contents/Resources/AppIcon.icns"
    run "/bin/cat",
        args:        ["{{staged_path}}/tex-messages-{{version}}/Resources/Info.plist"],
        stdout_path: "TeX Messages.app/Contents/Info.plist"
    run "/usr/bin/codesign",
        args:         ["--force", "--deep", "--sign", "-", "{{staged_path}}/TeX Messages.app"],
        print_stderr: false
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
