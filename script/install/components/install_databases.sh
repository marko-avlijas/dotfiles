#! /bin/bash

# load common.sh if it isn't loaded
[ -z "$DOTFILES_DIR_ABS" ] && source "$(dirname "$0")/common.sh"

LAB_DIR="$HOME/lab"

info_msg "Installing postgresql and sqlite3"
sudo apt install -y sqlite3 libsqlite3-dev postgresql libpq-dev postgresql-doc
success_msg "Install postgresql and sqlite3"
