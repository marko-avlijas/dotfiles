#! /bin/bash

script_dir="$(dirname "$(dirname "$BASH_SOURCE")")"
install_dir="$script_dir/install"

source "$script_dir/lib/all.sh"

info_msg "Starting installation"

distro_package_manager_update

source "$install_dir/install_git.sh"
source "$install_dir/install_tmux.sh"

success_msg "git and tmux installed"
