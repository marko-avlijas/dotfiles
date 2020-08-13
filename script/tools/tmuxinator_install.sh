#! /bin/bash

# Usage: tmuxinator_install.sh directory_with_dot_tmuxinator_file
# Directory is assumed to be $DOTFILES_INSTALL_DIR

# Example: tmuxinator_install.sh 3_parallel_install_1st_batch

# load script/lib/all.sh if it isn't loaded
[ -z "$DOTFILES_DIR_ABS" ] && source "$(dirname "$(dirname "$BASH_SOURCE")")/lib/all.sh"

read_sudo_password_and_save_it_in_tmp_file

# start tmuxinator and wait for it to finish
DOTFILES_DIR="$DOTFILES_DIR_ABS" tmuxinator start --project-config="${DOTFILES_BOOTSTRAP_DIR}/$1/.tmuxinator.yml"

delete_sudo_password

success_msg "tmuxinator_install '$1' complete!"
