#! /bin/bash

# compile neovim from source (because ubuntu likes to have very outdated packages)

# based on:
#   https://github.com/neovim/neovim/wiki/Building-Neovim
#   https://github.com/neovim/neovim/wiki/Installing-Neovim#install-from-source

# load script/lib/all.sh if it isn't loaded
[ -z "$DOTFILES_DIR_ABS" ] && source "$(dirname "$(dirname "$BASH_SOURCE")")/lib/all.sh"

if command_exists nvim; then
  info_msg "nvim already installed - skipping"
  return 0
fi

info_msg "Installing nvim prerequisites"

# install prerequisites
distro_package_manager_install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip

info_msg "Compiling neovim"

# clone repo
mkdir -p "$DOTFILES_SRC_DIR"
cd "$DOTFILES_SRC_DIR"
git clone https://github.com/neovim/neovim
cd neovim
git checkout stable

make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install

if ! command_exists nvim; then
  fail_msg_and_exit "Install nvim"
else
  success_msg "Compiled neovim"
fi
