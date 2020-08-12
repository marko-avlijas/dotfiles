#! /bin/bash

# load common.sh if it isn't loaded
[ -z "$DOTFILES_DIR_ABS" ] && source "$(dirname "$0")/common.sh"

info_msg "Manual steps remaining:\n"

echo Remap CAPS LOCK to CTRL

echo -e "\n\n\n"

echo -e "Add key to https://github.com/settings/keys \n\n"
cat "$HOME/.ssh/github_rsa.pub"

echo -e "\n\n\n"

echo -e "Add key to https://bitbucket.org/account/settings/ssh-keys/ \n\n"
cat "$HOME/.ssh/bitbucket_rsa.pub"
