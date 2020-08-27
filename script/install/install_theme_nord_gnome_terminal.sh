#! /bin/bash

# load script/lib/all.sh if it isn't loaded
[ -z "$DOTFILES_DIR_ABS" ] && source "$(dirname "$(dirname "$BASH_SOURCE")")/lib/all.sh"

info_msg "Installing nord gnome terminal"

distro_package_manager_install dconf-tools dconf-gsettings-backend dconf-cli dconf-service uuid-runtime

cd "$DOTFILES_SRC_DIR"

git clone https://github.com/arcticicestudio/nord-gnome-terminal.git
cd nord-gnome-terminal/src
./nord.sh

cd "$OLD_WORKING_DIRECTORY"

success_msg "Install nord gnome terminal"

info_msg "Please set nord as default theme in gnome terminal preferences"
