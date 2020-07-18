#! /bin/bash

# load common.sh if it isn't loaded
[ -z "$DOTFILES_DIR_ABS" ] && source "$(dirname "$0")/common.sh"

info_msg "Installing zsh"

sudo apt -y install zsh

if ! command_exists zsh; then
 fail_msg_and_exit "Install zsh"
fi

success_msg "zsh"

info_msg "Making zsh default shell"

sudo chsh -s $(which zsh) $USER

if [ -n $(grep $USER /etc/passwd | grep $(which zsh)) ]; then
  success_msg "zsh is default shell"
else
  fail_msg_and_exit "Could not make zsh default shell"
fi

