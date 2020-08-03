#! /bin/bash

# load common.sh if it isn't loaded
[ -z "$DOTFILES_DIR_ABS" ] && source "$(dirname "$0")/common.sh"

LAB_DIR="$HOME/lab"

info_msg "Installing node"

distro_package_manager_install nodejs

success_msg "Install node"
