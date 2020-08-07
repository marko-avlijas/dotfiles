#! /bin/bash

# load common.sh if it isn't loaded
[ -z "$DOTFILES_DIR_ABS" ] && source "$(dirname "$0")/common.sh"

# Configure vim
info_msg "Configuring vim"
ln -sfv "$DOTFILES_DIR_REL_FROM_HOME/config/vim/vimrc" "$HOME/.vimrc"
success_msg "Configure vim"

# Configure neovim
info_msg "Configuring neovim"
mkdir -p "$HOME/.config/nvim"
ln -sfv "../../$DOTFILES_DIR_REL_FROM_HOME/config/neovim/init.vim" \
        "$HOME/.config/nvim/init.vim"
success_msg "Configure neovim"

# set nvim as default editor
info_msg "Setting nvim as default editor"

if [ -z $(which nvim) ]; then
  fail_msg_and_exit "Can't find nvim"
fi
nvim_path=$(which nvim)

# update-alternatives - maintain symbolic links determining default commands on Debian based systems
#                                  link            name   path         priority 
sudo update-alternatives --install /usr/bin/editor editor "$nvim_path" 1
sudo update-alternatives --set editor "$nvim_path"

sudo update-alternatives --install /usr/bin/vi vi "$nvim_path" 1
sudo update-alternatives --set vi "$nvim_path"

success_msg "Set nvim as default editor"
