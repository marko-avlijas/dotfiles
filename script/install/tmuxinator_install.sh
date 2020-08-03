#! /bin/bash

# Usage: tmuxinator_install.sh directory_with_dot_tmuxinator_file
# Directory is assumed to be $DOTFILES_INSTALL_DIR

# Example: tmuxinator_install.sh 3_parallel_install_1st_batch
# load common.sh if it's not loaded
[ -z "$DOTFILES_DIR_ABS" ] && source "$(dirname "$0")/components/common.sh"

# save sudo password in temp file
read -s -p "Please enter sudo password: "
echo "$REPLY" > "$DOTFILES_PASSWORD_FILE"
info_msg "Temporarily saved password to $DOTFILES_PASSWORD_FILE"

# change to correct directory
cd "${DOTFILES_INSTALL_DIR}/$1"

# start tmuxinator and wait for it to finish
tmuxinator start project "components_dir=$DOTFILES_INSTALL_COMPONENTS_DIR"

# delete sudo password from temp file
rm -v "$DOTFILES_PASSWORD_FILE"
info_msg "Deleted temporarily saved password in $DOTFILES_PASSWORD_FILE"

cd "$OLD_WORKING_DIRECTORY"

success_msg "Script complete"
