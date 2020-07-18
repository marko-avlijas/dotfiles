#! /bin/bash

components_dir="$(dirname "$BASH_SOURCE")/components"

source "$components_dir/common.sh"

info_msg "Starting installation"

sudo apt update

source "$components_dir/install_git.sh"
source "$components_dir/create_ssh_keys.sh"
source "$components_dir/install_standard_cli_utils.sh"
source "$components_dir/install_zsh.sh"

success_msg "dotfiles installed"
