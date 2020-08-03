#! /bin/bash

standard_cli_utils="wget curl tree xclip htop fd-find ripgrep"

# load common.sh if it isn't loaded
[ -z "$DOTFILES_DIR_ABS" ] && source "$(dirname "$0")/common.sh"

info_msg "Installing standard cli utilities:\n$standard_cli_utils"

distro_package_manager_install $standard_cli_utils

# for ubuntu only because it installs packages with weird names
fdfind_path="$(which fdfind)"
if [ -z $fdfind_path ]; then
  sudo ln -sv "fd" "$fdfind_path"
else
  fail_msg_and_exit "fdfind installation failed"
fi

success_msg "$standard_cli_utils"
