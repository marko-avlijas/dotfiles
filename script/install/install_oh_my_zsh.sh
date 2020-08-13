#! /bin/bash

# load script/lib/all.sh if it isn't loaded
[ -z "$DOTFILES_DIR_ABS" ] && source "$(dirname "$(dirname "$BASH_SOURCE")")/lib/all.sh"

if [ -d "$HOME/.oh-my-zsh" ]; then
  info_msg "oh my zsh already installed - skipping"
  exit 0
fi

distro_package_manager_install curl

info_msg "Installing oh my zsh"

# TODO: download script first, read it and then install
# to avoid security risks
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

success_msg "oh my zsh"
