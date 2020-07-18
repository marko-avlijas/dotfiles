#! /bin/bash

# installs zsh
# oh my zsh will make zsh default shell, no need to duplicate that code

# load common.sh if it isn't loaded
[ -z "$DOTFILES_DIR_ABS" ] && source "$(dirname "$0")/common.sh"

info_msg "Installing zsh"

sudo apt -y install zsh zsh-doc powerline fonts-powerline

if ! command_exists zsh; then
 fail_msg_and_exit "Install zsh"
fi

success_msg "zsh"

