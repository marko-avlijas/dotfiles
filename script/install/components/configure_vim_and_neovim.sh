#! /bin/bash

# load common.sh if it isn't loaded
[ -z "$DOTFILES_DIR_ABS" ] && source "$(dirname "$0")/common.sh"

info_msg "Configuring vim"
ln -sfv "$DOTFILES_DIR_REL_FROM_HOME/config/vim/vimrc" "$HOME/.vimrc"
success_msg "Configure vim"

info_msg "Configuring neovim"
mkdir -p "$HOME/.config/nvim"
ln -sfv "../../$DOTFILES_DIR_REL_FROM_HOME/config/neovim/init.vim" \
        "$HOME/.config/nvim/init.vim"
success_msg "Configure neovim"

