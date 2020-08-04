#! /bin/bash

# load common.sh if it isn't loaded
[ -z "$DOTFILES_DIR_ABS" ] && source "$(dirname "$0")/common.sh"

for ((i=1; i<= DOTFILES_PACKAGE_MANAGER_LOCK_TRIES; i++)); do
  echo "Testing for loop: $i"
done

create_lock() {
  create_package_manager_lock "$(caller)"
}

create_lock

info_msg "Doing locked work 1"
sleep 2

info_msg "Doing locked work 2"
sleep 2

info_msg "Doing locked work 3"
sleep 2

info_msg "Doing locked work 4"
sleep 2

info_msg "Doing locked work 5"
sleep 2

delete_package_manager_lock

distro_package_manager_install "no_such_package I HOPE"
