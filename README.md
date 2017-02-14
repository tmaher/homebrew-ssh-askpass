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
