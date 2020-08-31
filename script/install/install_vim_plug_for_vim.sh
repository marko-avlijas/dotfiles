#! /bin/bash

# load script/lib/all.sh if it isn't loaded
[ -z "$DOTFILES_DIR_ABS" ] && source "$(dirname "$(dirname "$BASH_SOURCE")")/lib/all.sh"

# install vim plug for vim

info_msg "Installing vim plug for vim"

# TODO: create list of safe scripts instead of just downloading from internet and executing
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

success_msg "Install vim plug for vim"

info_msg "Installing vim plugings"
vim +PlugInstall +qall
success_msg "Install vim plugings"
