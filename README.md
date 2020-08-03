# dotfiles

My configuration files & parallel installation scripts.

Reason for this project is:
  * to keep configuration in one place (vim, tmux, git ...)
  * to automate installation process on a new computer

Tested on Ubuntu Ubuntu 20.04 LTS. Should work on Ubuntu-based distros like Linux Mint.

### Configuration explained

Configuration is done by symlinking files like `~/.vimrc` and `~/.tmux.conf` to versions in this repository in [config](config) folder.

### Installation explained

I have tried to get everything installed as quickly and comfortably as possible. Quickly means doing parallel installation whenever possible. Comfortably means using tmux and vim ASAP.

That was the reason behind dividing installation like it is.

#### Part 1

First there is nothing on computer and git and tmux need to be installed. Git is also setup to use your name and email.

[script/install/1_install_git_and_tmux.sh](script/install/1_install_git_and_tmux.sh)

#### Part 2

Tmux can now be used to make installation more comfortable, but I had to
manually code the tmux session. That code is verbose and it's much easier to just use tmuxinator. That's why this step is minimal.

It only installs: 
  - left pane: ruby & tmuxinator
  - right pane: zsh & oh my zsh

[script/install/2_install_zsh_and_ruby_inside_tmux.sh](script/install/2_install_zsh_and_ruby_inside_tmux.sh)

#### Part 3

Here is where mass parallel installation starts. Everything that has no dependencies (expect what's installed in steps 1 and 2) is installed now.
Everything with dependencies gets installed in part 4.

First you are asked to enter sudo password. This is saved to a file in tmp dir and should be automatically deleted after tmuxinator is finished. This is to avoid entering sudo password in every tmux pane.

You can see what's going to be installed in this step here:
[script/install/3_parallel_install_1st_batch/.tmuxinator.yml](script/install/3_parallel_install_1st_batch/.tmuxinator.yml)

#### Part 4

Everything that depends on something from step 3 can be installed now.
For example I am installing rails in this step because it depends on node and yarn and databases which are installed in step 3.


## How to install

**This is to be run on new computer.**
**This will destroy your old configuration files!**

First cd into dotfiles directory.
Then:

    cp config/git/gitconfig_secret.example config/git/gitconfig_secret

Now open `config/git/gitconfig_secret` in your text editor and fill it with your git user name and email.

Now install it in parts as laid out in `script/install`

    ./script/install/1_install_git_and_tmux.sh
    ./script/install/2_install_zsh_and_ruby_inside_tmux.sh

After every part check that everything was executed correctly.

Pick and choose what to install by changing `.tmuxinator.yml` files in
[3_parallel_install_1st_batch directory](script/install/3_parallel_install_1st_batch/.tmuxinator.yml) and
[4_parallel_install_2nd_batch directory](script/install/4_parallel_install_2nd_batch/.tmuxinator.yml). Then run:

    ./script/install/3_parallel_install_1st_batch.zsh
    ./script/install/4_parallel_install_2nd_batch.zsh

Individual install components are in [script/install/components](script/install/components)

## Update [TODO]

Some stuff is compiled from source or gotten from github release page. You can update those by using scripts in `update` directory.
If you never update it will still be newer than Ubuntu packages.

## What's inside?

Please checkout these directories:

* [config](config)
* [install/script/components](install/script/components)

I use neovim & vim as editor, tmux and zsh and have some git aliases.
I am a rails developer so I have to install ruby, node, yarn, postgresql, sqlite and rails.

Maybe somewhat exotic stuff are:

fd (faster find, respects .gitignore, written in rust)
https://github.com/sharkdp/fd

ripgrep (faster grep, respects .gitignore, written in rust)
https://github.com/BurntSushi/ripgrep

bat (cat with syntax highlighting, written in rust)
https://github.com/sharkdp/bat/

To do:

* choose themes for vim and tmux (maybe https://github.com/rafi/awesome-vim-colorschemes)
* setup terminal themes (maybe not necessary?)
* install other cli utils (rg, fd, bat)
* install postgresql

## What's left to do

These are things I couldn't automate and I need to do manually before I can start writing software.

* remap CAPS LOCK to CTRL
* add generated ssh keys to github and bitbucket
* install tmux plugins (press prefix + I inside tmux)
