#! /bin/bash

# load script/lib/all.sh if it isn't loaded
[ -z "$DOTFILES_DIR_ABS" ] && source "$(dirname "$(dirname "$BASH_SOURCE")")/lib/all.sh"

info_msg "Installing postgresql and sqlite3"

distro_package_manager_install sqlite3 libsqlite3-dev postgresql libpq-dev postgresql-doc

success_msg "Install postgresql and sqlite3"


info_msg "Creating default user"

sudo -u postgres createuser --superuser $(whoami)

success_msg "Create default user"
