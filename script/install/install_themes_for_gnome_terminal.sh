#! /bin/bash

# load script/lib/all.sh if it isn't loaded
[ -z "$DOTFILES_DIR_ABS" ] && source "$(dirname "$(dirname "$BASH_SOURCE")")/lib/all.sh"

info_msg "Installing themes for gnome terminal"

distro_package_manager_install dconf-cli uuid-runtime

cd $DOTFILES_SRC_DIR
if [ -d gogh ]; then
  cd gogh && git pull
else
  git clone https://github.com/Mayccoll/Gogh.git gogh
  cd gogh
fi

cd themes

# necessary on ubuntu
export TERMINAL=gnome-terminal

# install themes
./atom.sh
./dracula.sh
./freya.sh
./nord.sh
./oceanic-next.sh
./one-dark.sh
chmod +x ./palenight.sh
./palenight.sh
./solarized-darcula.sh

cd $OLD_WORKING_DIRECTORY

success_msg "Install themes for gnome terminal"

info_msg "You can now choose a default theme in gnome terminal preferences"
