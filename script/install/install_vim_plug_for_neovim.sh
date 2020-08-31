#! /bin/bash

# load script/lib/all.sh if it isn't loaded
[ -z "$DOTFILES_DIR_ABS" ] && source "$(dirname "$(dirname "$BASH_SOURCE")")/lib/all.sh"

# install vim plug for neovim

info_msg "Installing vim plug for neovim"

# TODO: create list of safe scripts instead of just downloading from internet and executing
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

success_msg "Install vim plug for neovim"

info_msg "Installing neovim plugings"
nvim +PlugInstall +qall
success_msg "Install neovim plugings"
