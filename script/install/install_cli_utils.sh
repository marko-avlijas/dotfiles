#! /bin/bash

cli_utils="wget curl tree xclip htop"

# load script/lib/all.sh if it isn't loaded
[ -z "$DOTFILES_DIR_ABS" ] && source "$(dirname "$(dirname "$BASH_SOURCE")")/lib/all.sh"

info_msg "Installing command line utilities:\n$cli_utils"

distro_package_manager_install $cli_utils

success_msg "$cli_utils"
