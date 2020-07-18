#! /bin/bash

# load common.sh if it isn't loaded
[ -z "$DOTFILES_DIR_ABS" ] && source "$(dirname "$0")/common.sh"

info_msg "Installing oh my zsh"

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

success_msg "oh my zsh"
