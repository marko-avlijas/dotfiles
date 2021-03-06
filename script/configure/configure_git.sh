#! /bin/bash

# load script/lib/all.sh if it isn't loaded
[ -z "$DOTFILES_DIR_ABS" ] && source "$(dirname "$(dirname "$BASH_SOURCE")")/lib/all.sh"

# Create symbolic links to git dotfiles
info_msg "Configuring git\n"

echo "Creating symlinks:"
git_dotfiles=( "gitconfig" "gitignore_global" "gitconfig_secret" )
for i in "${git_dotfiles[@]}"; do
  ln -sfv "$DOTFILES_DIR_REL_FROM_HOME/config/git/$i" "$HOME/.$i"
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
