#! /bin/bash

script_dir="$(dirname "$(dirname "$BASH_SOURCE")")"

source "$script_dir/lib/all.sh"

info_msg "Starting installation"

distro_package_manager_update

source "$DOTFILES_INSTALL_DIR/install_git.sh"
source "$DOTFILES_CONFIGURE_DIR/configure_git.sh"

source "$DOTFILES_INSTALL_DIR/install_tmux.sh"
source "$DOTFILES_CONFIGURE_DIR/configure_tmux.sh"

source "$DOTFILES_INSTALL_DIR/install_theme_nord_gnome_terminal.sh"

success_msg "git and tmux installed"
