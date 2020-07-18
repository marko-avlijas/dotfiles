#! /bin/bash

# Create ssh keys with empty passphrase for github and bitbucket
# Does not create keys if they exist

# load common.sh if it isn't loaded
[ -z "$DOTFILES_DIR_ABS" ] && source "$(dirname "$0")/common.sh"

my_git_user_email="$(git config user.email)"

# Creates rsa key in "$HOME/.ssh/$1"
create_ssh_key () {
  if [ ! -f "$1" ]; then
    ssh-keygen -t rsa -b 4096 -C "$my_git_user_email" -N "" -f "$1"
    
    if [ -f "$1" ]; then
      success_msg "$1"
    else
      fail_msg_and_exit "$1"
    fi
  else
    info_msg "Skipping '$1' (already exists)"
  fi
}

info_msg "Creating github_rsa and bitbucket_rsa ssh keys\n"

create_ssh_key "$HOME/.ssh/github_rsa"
create_ssh_key "$HOME/.ssh/bitbucket_rsa"


