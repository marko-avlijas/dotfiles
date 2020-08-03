#! /bin/bash

# load common.sh if it isn't loaded
[ -z "$DOTFILES_DIR_ABS" ] && source "$(dirname "$0")/common.sh"

LAB_DIR="$HOME/lab"

# https://classic.yarnpkg.com/en/docs/install/#debian-stable
info_msg "Installing yarn"

curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
distro_package_manager_uninstall cmdtest # can cause problems on some ubuntu versions
sudo apt update
distro_package_manager_install yarn

success_msg "Install yarn"
