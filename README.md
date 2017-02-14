homebrew-ssh-askpass
====================

Homebrew tap for ssh-askpass
See https://github.com/Homebrew/brew/blob/master/docs/brew-tap.md

Tired of forwarding your ssh-agent connection to remote hosts and crossing
your fingers that the socket won't get hijacked? Well wait no more!

Since the days of X11, `ssh-agent` has had hooks to prompt the user whenever
it receives a signing request. Unfortunately, it's not immediately usable
on macOS. This formula fixes that.

1. Make sure [Homebrew](https://brew.sh/) is installed.
2. `brew update`
3. `brew tap tmaher/ssh-askpass`
4. `brew install ssh-askpass`

## About Sierra & auto-loading
Prior to Sierra (10.12), macOS would attempt to auto-load private keys into
`ssh-agent`. That functionality was removed in Sierra, and now users are
on the hook for loading keys themselves. Usually the advice is something
like adding `ssh-add -K` to `~/.bashrc`, or more sophisticated things like
[adding a custom LaunchAgent](https://github.com/jirsbek/SSH-keys-in-macOS-Sierra-keychain).

This Homebrew formula follows the LaunchAgent approach. In order for
confirmation-on-use to work, when a private key is loaded into agent, a
flag must be set indicating confirmation-on-use is required. After setting
the necessary environment variables and restarting `ssh-agent`, the command
`ssh-add -cA` is run. This auto-loads the keys (as was done prior to Sierra),
and marks them as requiring confirmation-on-use.

See https://developer.apple.com/library/content/technotes/tn2449/_index.html
for some additional details on Apple's OpenSSH changes in Sierra.
