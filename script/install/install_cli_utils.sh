#! /bin/bash

standard_cli_utils="wget curl tree xclip htop"

# load common.sh if it isn't loaded
[ -z "$DOTFILES_DIR_ABS" ] && source "$(dirname "$0")/common.sh"

info_msg "Installing standard cli utilities:\n$standard_cli_utils"

distro_package_manager_install $standard_cli_utils

success_msg "$standard_cli_utils"
