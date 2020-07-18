# dotfiles

My configuration files & install scripts.

Tested on Ubuntu Ubuntu 20.04 LTS. Should work on Ubuntu-based distros like Linux Mint.

## Installation

**This is to be run on new computer.**
**This will destroy your old configuration files!**

First cd into dotfiles directory.

    cp git/gitconfig_secret.example git/gitconfig_secret

Now open `git/gitconfig_secret` in your text editor and fill it with your git user name and email.

To install everything: `./install/bootstrap.sh`

Or pick and choose what to install by calling individual scripts in `install` directory.


## What's inside?

* install & configure git
* create github_rsa and bitbucket_rsa ssh keys (no passphrase)

To do:

* install zshell & omgzsh
* compile vim from source
* configure vim
* setup 24-bit color in terminal (this works out of the box)
* setup terminal themes
* install & configure tmux
* install cli tools (rg, fd, bat, fzf, curl)
* install ruby using ruby-install and chruby
* list remaining manual actions

## What's left to do

These are things I didn't bother to automate and I need to do manually before I can start writing software.

* remap CAPS LOCK to CTRL
* add generated ssh keys to github and bitbucket
