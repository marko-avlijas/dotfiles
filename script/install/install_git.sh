#! /bin/bash

# load script/lib/all.sh if it isn't loaded
[ -z "$DOTFILES_DIR_ABS" ] && source "$(dirname "$(dirname "$BASH_SOURCE")")/lib/all.sh"

info_msg "Installing git\n"

distro_package_manager_install git gitk meld

if ! command_exists git; then
 fail_msg_and_exit "Install git"
fi

success_msg "Install git"
