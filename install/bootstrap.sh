#! /bin/bash

install_dir=$(dirname "$BASH_SOURCE")

source "$install_dir/common.sh"

info_msg "Starting installation"

# sudo apt-get update

source "$install_dir/install_git.sh"
source "$install_dir/create_ssh_keys.sh"

success_msg "dotfiles installed"
