#! /bin/bash

# compile neovim from source (because ubuntu likes to have very outdated packages)

# based on:
#   https://github.com/neovim/neovim/wiki/Building-Neovim
#   https://github.com/neovim/neovim/wiki/Installing-Neovim#install-from-source

NEOVIM_SRC_DIR="$HOME/src"

# load common.sh if it isn't loaded
[ -z "$DOTFILES_DIR_ABS" ] && source "$(dirname "$0")/common.sh"

if command_exists nvim; then
  info_msg "nvim already installed - skipping"
  return 0
fi

info_msg "Installing nvim prerequisites"

# install prerequisites
sudo apt -y install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip

info_msg "Compiling neovim"

# clone repo
mkdir -p "$NEOVIM_SRC_DIR"
cd "$NEOVIM_SRC_DIR"
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
