# dotfiles

My configuration files & install scripts.

Tested on Ubuntu Ubuntu 20.04 LTS. Should work on Ubuntu-based distros like Linux Mint.

## Installation

**This is to be run on new computer.**
**This will destroy your old configuration files!**

First cd into dotfiles directory.

    cp gitconfig_secret.example gitconfig_secret

Now open gitconfig_secret in your text editor and fill it with your git user name and email.

To install everything: `./install/bootstrap.sh`

Or pick and choose what to install by calling individual scripts.


## What's inside?

* install & configure git
* create github_rsa and bitbucket_rsa ssh keys (no passphrase)

## What's left to do

These are things I didn't bother to automate and I need to do before I can start writing software.

* remap CAPS LOCK to CTRL
* add generated ssh keys to github and bitbucket
