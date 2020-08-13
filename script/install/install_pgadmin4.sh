#! /bin/bash

# load script/lib/all.sh if it isn't loaded
[ -z "$DOTFILES_DIR_ABS" ] && source "$(dirname "$(dirname "$BASH_SOURCE")")/lib/all.sh"

LAB_DIR="$HOME/lab"

# https://www.postgresql.org/ftp/pgadmin/pgadmin4/apt/

info_msg "Installing pgadmin4"

#
# Setup the repository
#

# Install the public key for the repository (if not done previously):
curl https://www.pgadmin.org/static/packages_pgadmin_org.pub | feed_password_into_sudo apt-key add

# Create the repository configuration file:
feed_password_into_sudo sh -c 'echo "deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list'
distro_package_manager_update

#
# Install pgAdmin
#

# Install for both desktop and web modes:
# sudo apt install pgadmin4

# Install for desktop mode only:
# sudo apt install pgadmin4-desktop

# Install for web mode only: 
distro_package_manager_install pgadmin4-web 

# Configure the webserver, if you installed pgadmin4-web:
feed_password_into_sudo /usr/pgadmin4/bin/setup-web.sh

success_msg "Install pgadmin4"
