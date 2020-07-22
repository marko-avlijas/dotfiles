# dotfiles

My configuration files & install scripts.

Tested on Ubuntu Ubuntu 20.04 LTS. Should work on Ubuntu-based distros like Linux Mint.

## Installation

**This is to be run on new computer.**
**This will destroy your old configuration files!**

First cd into dotfiles directory.
Then:

    cp git/gitconfig_secret.example git/gitconfig_secret

Now open `git/gitconfig_secret` in your text editor and fill it with your git user name and email.

To install everything: `./install/bootstrap.sh`

Or pick and choose what to install by calling individual scripts in `install` directory.

## Update [TODO]

Some stuff is compiled from source or gotten from github release page. You can update those by using scripts in `update` directory.
If you never update it will still be newer than Ubuntu packages.

## What's inside?

* install & configure git
* create github_rsa and bitbucket_rsa ssh keys (no passphrase)
* install command line utilities (see list bellow)
* install zshell & oh my zsh
* compile neovim from source
* setup 24-bit color in terminal (this works out of the box on ubuntu 20.04)
* list remaining manual actions

## Command line utilities

Standard ones: wget curl tree

fd (faster find, respects .gitignore, written in rust)
https://github.com/sharkdp/fd

ripgrep (faster grep, respects .gitignore, written in rust)
https://github.com/BurntSushi/ripgrep

bat (cat with syntax highlighting, written in rust)
https://github.com/sharkdp/bat/

To do:

* compile vim from source
* configure vim
* install & configure tmux
* setup terminal themes
* install other cli utils (rg, fd, bat)
* install ruby using ruby-install and chruby

## What's left to do

These are things I couldn't automate and I need to do manually before I can start writing software.

* remap CAPS LOCK to CTRL
* add generated ssh keys to github and bitbucket
* install tmux plugins (press prefix + I inside tmux)
