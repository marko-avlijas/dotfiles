#! /bin/bash

# load script/lib/all.sh if it isn't loaded
[ -z "$DOTFILES_DIR_ABS" ] && source "$(dirname "$(dirname "$BASH_SOURCE")")/lib/all.sh"

info_msg "Installing fzf"

git clone --depth 1 "https://github.com/junegunn/fzf.git" "$DOTFILES_SRC_DIR/fzf"
"$DOTFILES_SRC_DIR/fzf/install" --no-key-bindings --no-completion --no-update-rc

success_msg "install fzf"
