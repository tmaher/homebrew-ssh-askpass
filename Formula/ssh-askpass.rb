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

  def ssh_add_cmd
    ":" unless Formula['go-ssh-add'] && Formula['go-ssh-add'].opt_bin
    File.join(Formula['go-ssh-add'].opt_bin, "go-ssh-add")
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
        '#{ssh_add_cmd}' add-all 2>/dev/null
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

  def caveats; <<-EOF.undent
    For now, you need to load your keys by hand (actual path to key may vary):

      ssh-add -c $HOME/.ssh/id_rsa

    The LaunchAgent is because we need to hook ssh-agent's environment. Ignore
    the instruction to `launchctl load`; you have to log out/back in.
    EOF
  end
end
