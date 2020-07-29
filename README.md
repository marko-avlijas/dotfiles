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

Now install it in parts as laid out in `script/install`

    ./script/install/1_install_git_and_tmux.sh
    ./script/install/2_before_zsh_and_zsh.sh

Parts 2 and later are going to be done in tmux. It's best to open normal terminal window (not inside tmux) and maximize it.
After every part check that everything was executed correctly.

Or pick and choose what to install by calling individual scripts in `script/install` directory.

## Update [TODO]

Some stuff is compiled from source or gotten from github release page. You can update those by using scripts in `update` directory.
If you never update it will still be newer than Ubuntu packages.

## What's inside?

* setup 24-bit color in terminal (this works out of the box on ubuntu 20.04)
* install & configure git
* create github_rsa and bitbucket_rsa ssh keys (no passphrase)
* install command line utilities (see list bellow)
* install zshell & oh my zsh
* compile neovim from source
* install & configure tmux
* install ruby using ruby-install and chruby
* install rails & dependecies
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
* choose themes for vim and tmux (maybe https://github.com/rafi/awesome-vim-colorschemes)
* setup terminal themes (maybe not necessary?)
* install other cli utils (rg, fd, bat)

## What's left to do

These are things I couldn't automate and I need to do manually before I can start writing software.

* remap CAPS LOCK to CTRL
* add generated ssh keys to github and bitbucket
* install tmux plugins (press prefix + I inside tmux)
