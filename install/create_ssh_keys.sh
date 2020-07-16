#! /bin/bash

# load common.sh if it isn't loaded
[ -z "$DOTFILES_DIR" ] && source "$(dirname "$0")/common.sh"

# Create ssh keys with empty passphrase for github and bitbucket

info_msg "Creating github_rsa and bitbucket_rsa ssh keys"

my_git_user_email="$(git config user.email)"

ssh-keygen -t rsa -b 4096 -C "$my_git_user_email" -N "" -f "$HOME/.ssh/github_rsa"
ssh-keygen -t rsa -b 4096 -C "$my_git_user_email" -N "" -f "$HOME/.ssh/bitbucket_rsa"

success_msg "github_rsa and bitbucket_rsa"

