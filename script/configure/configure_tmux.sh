#! /bin/bash

# load script/lib/all.sh if it isn't loaded
[ -z "$DOTFILES_DIR_ABS" ] && source "$(dirname "$(dirname "$BASH_SOURCE")")/lib/all.sh"


# Create symbolic link to .tmux.conf

info_msg "Configuring tmux\n"

echo "Creating symlink:"
ln -sfv "$DOTFILES_DIR_REL_FROM_HOME/config/tmux/tmux.conf" "$HOME/.tmux.conf"

success_msg "Configure tmux"


# Install tpm (tmux plugin manager"

info_msg "Installing tmux plugin manager"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
info_msg "Install tpm"

echo "Press prefix + I (inside tmux) to install tmux plugins"
