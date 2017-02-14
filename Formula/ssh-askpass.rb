require 'formula'

# Homebrew formula to install ssh password asker
class SshAskpass < Formula
  homepage 'https://github.com/tmaher/ssh-askpass/'
  url 'https://codeload.github.com/tmaher/ssh-askpass/tar.gz/v1.1.1'
  sha256 'd1e2b4a48eff2ea55226159f06c31a900145acf7d4cfded673d3fdbe37677a48'

  DISPLAY_TEXT='https://github.com/openssh/openssh-portable/blob/94141b7/readpass.c#L144-L156'.freeze

  def install
    bin.install 'ssh-askpass'
  end

  def post_install
    Kernel.system 'brew services start ssh-askpass ||
      brew services restart ssh-askpass ||
      true'
  end

  def plist; <<-EOS.undent
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
    <key>Label</key>
    <string>#{plist_name}</string>
    <key>ProgramArguments</key>
    <array>
      <string>/bin/sh</string>
      <string>-c</string>
      <string>
        /bin/launchctl setenv SSH_ASKPASS '#{opt_bin}/ssh-askpass'
        /bin/launchctl setenv DISPLAY \"${DISPLAY:-#{DISPLAY_TEXT}}\"
        /usr/bin/ssh-add -l
        /bin/launchctl stop com.openssh.ssh-agent
        /usr/bin/ssh-add -cA
        true
      </string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>ServiceIPC</key>
    <false/>
  </dict>
</plist>
    EOS
  end

  def caveats; <<-EOS.undent
TO REVERT THIS

  brew services stop #{plist_name}
  brew uninstall ssh-askpass

...and then restart
    EOS
  end
end
