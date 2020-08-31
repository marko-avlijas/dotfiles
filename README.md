# dotfiles

My configuration files & parallel installation scripts.

Reason for this project is:
  * to keep configuration in one place (vim, tmux, git ...)
  * to automate installation process on a new computer

Tested on Ubuntu Ubuntu 20.04 LTS. Should work on Ubuntu-based distros like Linux Mint.

## How to install

**This is to be run on new computer.**
**This will destroy your old configuration files!**

First cd into dotfiles directory.
Then:

    cp config/git/gitconfig_secret.example config/git/gitconfig_secret

Now open `config/git/gitconfig_secret` in your text editor and fill it with your git user name and email.

Now install it in parts as laid out in `script/install`

    ./script/bootstrap/1_install_git_and_tmux.sh
    ./script/bootstrap/2_install_zsh_and_ruby_inside_tmux.sh

After every part check that everything was executed correctly.

Pick and choose what to install by changing `.tmuxinator.yml` files in
[script/bootstrap/3_install_1st_batch/.tmuxinator.yml](script/bootstrap/3_install_1st_batch/.tmuxinator.yml) and
[script/bootstrap/4_install_2nd_batch/.tmuxinator.yml](script/bootstrap/4_install_2nd_batch/.tmuxinator.yml). Then run:

    ./script/tools/tmuxinator_install.sh 3_install_1st_batch
    ./script/tools/tmuxinator_install.sh 4_install_2nd_batch

Individual install files are in [script/install](script/install)
and can be run independently if you wish so.

### Understanding directory structure

* config dir holds configuration files like `vimrc`
* script dir holds all logic

script
* bootstrap  - install everything on new computer
* configure  - configure installed or updated tools
* install    - install parts like vim or tmux
* lib        - common code for all shell scripts
* remove     - uninstall parts like vim or tmux **todo**
* tools      - stuff like color_test etc
* update     - update installed software **todo**


### Configuration explained

Configuration is done by symlinking files like `~/.vimrc` and `~/.tmux.conf` to versions in this repository in [config](config) folder.

### Installation explained

I have tried to get everything installed as quickly and comfortably as possible. Quickly means doing parallel installation whenever possible. Comfortably means using tmux and vim ASAP.

That was the reason behind dividing installation like it is.

#### Part 1

First there is nothing on computer and git and tmux need to be installed. Git is also setup to use your name and email.

[script/bootstrap/1_install_git_and_tmux.sh](script/bootstrap/1_install_git_and_tmux.sh)

#### Part 2

Tmux can now be used to make installation more comfortable, but I had to
manually code the tmux session. That code is verbose and it's much easier to just use tmuxinator. That's why this step is minimal.

It only installs: 
  - left pane: ruby & tmuxinator
  - right pane: zsh & oh my zsh

[script/bootstrap/2_install_zsh_and_ruby_inside_tmux.sh](script/bootstrap/2_install_zsh_and_ruby_inside_tmux.sh)

#### Part 3

Here is where mass parallel installation starts. Everything that has no dependencies (expect what's installed in steps 1 and 2) is installed now.
Everything with dependencies gets installed in part 4.

First you are asked to enter sudo password. This is saved to a file in tmp dir and should be automatically deleted after tmuxinator is finished. This is to avoid entering sudo password in every tmux pane.

You can see what's going to be installed in this step here:
[script/bootstrap/3_install_1st_batch/.tmuxinator.yml](script/bootstrap/3_install_1st_batch/.tmuxinator.yml)

#### Part 4

Everything that depends on something from step 3 can be installed now.

You can see what's going to be installed in this step here:
[script/bootstrap/4_install_2nd_batch/.tmuxinator.yml](script/bootstrap/4_install_2nd_batch/.tmuxinator.yml)


## Update [TODO]

Some stuff is compiled from source or gotten from github release page. You can update those by using scripts in `update` directory.
If you never update it will still be newer than Ubuntu packages.

## What's inside?

Please checkout directory [config](config)

I use neovim & vim as editor, tmux and zsh and have some git aliases.
I am a rails developer so I have to install ruby, node, yarn, postgresql, sqlite and rails.

Maybe somewhat exotic stuff are:

fd (faster find, respects .gitignore, written in rust)
https://github.com/sharkdp/fd

ripgrep (faster grep, respects .gitignore, written in rust)
https://github.com/BurntSushi/ripgrep

bat (cat with syntax highlighting, written in rust)
https://github.com/sharkdp/bat/

### To do:

* choose themes for vim and tmux (maybe https://github.com/rafi/awesome-vim-colorschemes)
* install other cli utils (rg, fd, bat)
