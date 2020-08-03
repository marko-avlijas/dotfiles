#! /bin/bash

[ -z "$DOTFILES_DIR_ABS" ] && source "$(dirname "$0")/components/common.sh"

# save sudo password in temp file
read -s -p "Please enter sudo password: "
echo "Reply: $REPLY"
echo "Password file: $DOTFILES_PASSWORD_FILE"
echo "$REPLY" > "$DOTFILES_PASSWORD_FILE"

# start tmuxinator and wait for it to finish
cd "${DOTFILES_INSTALL_DIR}/3_parallel_install_1st_batch"
tmuxinator start project "components_dir=$DOTFILES_INSTALL_COMPONENTS_DIR"

# delete sudo password from temp file
rm -v "$DOTFILES_PASSWORD_FILE"

cd "$OLD_WORKING_DIRECTORY"
