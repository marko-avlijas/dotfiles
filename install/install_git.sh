#! /bin/bash

# load common.sh if it isn't loaded
[ -z "$DOTFILES_DIR" ] && source "$(dirname "$0")/common.sh"

info_msg "Installing git"

sudo apt-get install -y git gitk

if ! is_installed git; then
 fail_msg_and_exit "Install git"
fi

success_msg "Install git"

# Create symbolic links to git dotfiles
info_msg "Configuring git"

git_dotfiles=( "gitconfig" "gitignore_global" "gitconfig_secret" )
for i in "${git_dotfiles[@]}"; do
  ln -sfvr "$DOTFILES_DIR/git/$i" "$HOME/.$i"
done

# Verify git user.name and user.email are not empty
my_git_user_name="$(git config user.name)"
my_git_user_email="$(git config user.email)"

if [ -z "$my_git_user_name" ]; then
  fail_msg_and_exit "git user.name is not set"
fi

if [ -z "$my_git_user_email" ]; then
  fail_msg_and_exit "git user.email is not set"
fi

info_msg " git user.name == $my_git_user_name"
info_msg "git user.email == $my_git_user_email"

success_msg "Configured git"
