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
    ./script/install/2_install_zsh_and_ruby_inside_tmux.sh

After every part check that everything was executed correctly.

Pick and choose what to install by changing `.tmuxinator.yml` files in
`3_parallel_install_1st_batch` and `4_parallel_install_2nd_batch` directories.

    ./script/install/3_parallel_install_1st_batch.zsh
    ./script/install/4_parallel_install_2nd_batch.zsh


### Installation explained

I have tried to get everything installed as quickly and comfortably as possible. Quickly means doing parallel installation whenever possible. Comfortably means using tmux and vim ASAP.

That was the reason behind dividing installation like it is.

#### Part 1

First there is nothing on computer and git and tmux need to be installed. Git is also setup to use your name and email.

[1_install_git_and_tmux.sh]

#### Part 2

This is done inside tmux, but I had to manually code the tmux session. That code is verbose and it's much easier to just use tmuxinator. That's why this step is minimal.

It only installs: 
  - left pane: ruby & tmuxinator
  - right pane: zsh & oh my zsh

[script/install/2_install_zsh_and_ruby_inside_tmux.sh](script/install/2_install_zsh_and_ruby_inside_tmux.sh)

#### Part 3

Here is where mass parallel installation starts. Everything that has no dependencies (expect what's installed in steps 1 and 2) is installed now.

First you are asked to enter sudo password. This is saved to a file in tmp dir and should be deleted after tmuxinator is finished. This is to avoid entering sudo password in every tmux pane.

You can see what's going to be installed in this step here:
[script/install/3_parallel_install_1st_batch/.tmuxinator.yml](script/install/3_parallel_install_1st_batch/.tmuxinator.yml)

#### Part 4

Everything that depends on something from step 3 can be installed now.
For example I am installing rails in this step because it depends on node and yarn and databases which are installed in step 3.

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
