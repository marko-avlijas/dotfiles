#! /bin/bash

# load common.sh if it isn't loaded
[ -z "$DOTFILES_DIR_ABS" ] && source "$(dirname "$0")/common.sh"

if [ -d "$HOME/.oh-my-zsh" ]; then
  info_msg "oh my zsh already installed - skipping"
  return 0
fi

info_msg "Installing oh my zsh"

# TODO: download script first, read it and then install
# to avoid security risks
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

success_msg "oh my zsh"

# append: source "$DOTFILES_DIR_ABS/config/shell/bash_and_zsh.sh"
# to ~/.bashrc and ~/.zshrc
info_msg "Patching .bashrc and .zshrc"
source_bash_and_zsh="source "$DOTFILES_DIR_ABS/config/shell/bash_and_zsh.sh""

# append to ~/.bashrc
smart_append_to_file "$HOME/.bashrc" "# Load my configuration"
smart_append_to_file "$HOME/.bashrc" "$source_bash_and_zsh"

# append to ~/.zshrc
smart_append_to_file "$HOME/.zshrc" "# Load my configuration"
smart_append_to_file "$HOME/.zshrc" "$source_bash_and_zsh"
smart_append_to_file "$HOME/.zshrc" "source "$DOTFILES_DIR_ABS/config/shell/zsh.zsh""

success_msg "Patch .bashrc and .zshrc"
