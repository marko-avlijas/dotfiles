#! /bin/bash

# load script/lib/all.sh if it isn't loaded
[ -z "$DOTFILES_DIR_ABS" ] && source "$(dirname "$(dirname "$BASH_SOURCE")")/lib/all.sh"

# install tmux

info_msg "Installing tmux\n"

distro_package_manager_install tmux

if ! command_exists tmux; then
 fail_msg_and_exit "Install tmux"
fi

success_msg "Install tmux"
