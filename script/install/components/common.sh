#! /bin/bash

# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -Euo pipefail

# -x option causes bash to print each command before executing it
# which is useful for debugging
# you can set it anywhere in file like this
# set -x

DOTFILES_DIR_ABS="$(dirname "$(dirname "$(dirname "$(dirname "$(readlink -f "$BASH_SOURCE")")")")")"
DOTFILES_DIR_REL_FROM_HOME="${DOTFILES_DIR_ABS#"$HOME/"}"
DOTFILES_SRC_DIR="$HOME/src" # directory for cloning git repos

DOTFILES_INSTALL_DIR="$DOTFILES_DIR_ABS/script/install"
DOTFILES_INSTALL_COMPONENTS_DIR="$DOTFILES_INSTALL_DIR/components"

DOTFILES_TMP_DIR="$DOTFILES_DIR_ABS/tmp"
DOTFILES_PASSWORD_FILE="$DOTFILES_TMP_DIR/pass"
DOTFILES_PACKAGE_MANAGER_LOCK_DIR="$DOTFILES_TMP_DIR/lock"
DOTFILES_PACKAGE_MANAGER_LOCK_INFO_FILE="$DOTFILES_PACKAGE_MANAGER_LOCK_DIR/info"

# how many times to try to create the lock
DOTFILES_PACKAGE_MANAGER_LOCK_TRIES=300
# how long to sleep in seconds after I can't create a lock
DOTFILES_PACKAGE_MANAGER_LOCK_SLEEP_BETWEEN_TRIES=1

OLD_WORKING_DIRECTORY="$(pwd)"

echo "DOTFILES_DIR_ABS = $DOTFILES_DIR_ABS"
echo "DOTFILES_DIR_REL_FROM_HOME = $DOTFILES_DIR_REL_FROM_HOME"
echo "DOTFILES_SRC_DIR = $DOTFILES_SRC_DIR"

# check to see if command is installed (and is in $PATH)
command_exists()
{
  command -v "$1" >/dev/null 2>&1
}

# Appends given text to given file
# only if file already doesn't contain the text
#
# $1 - path of file to change
# $2 - text to add at the end of file

# Message is outputed to user that text was added or that it was skipped
# because text was already present in file

# Example:
# smart_append_to_file "$HOME/.zshrc" \
#                      "source /usr/local/share/chruby/chruby.sh"

smart_append_to_file() {
  local path="$1"
  local text="$2"

  if grep "$text" "$path" > /dev/null; then
    info_msg "Skipping - already present in $path:\n\t\t$text"
  else
    echo "$text" >> "$path" # append $text to $path
    success_msg "Added to $path: $text"
  fi

  return 0
}

# if $DOTFILES_PASSWORD_FILE exists it feeds it to sudo
# using sudo's --stdin option.
# Otherwise it just performs sudo with given arguments
# and user has to type the sudo password.
feed_password_into_sudo() {
  # "$@" means expand all parameters just like they were sent
  if [ -f $DOTFILES_PASSWORD_FILE ]; then
    cat "$DOTFILES_PASSWORD_FILE" | sudo --stdin "$@"
  else
    sudo "$@"
  fi
}

# Creates a lock on package manager (for all dotfiles scripts, not system wide).
# 
# Tries to read sudo password from $DOTFILES_PASSWORD_FILE
# Call distro package manager (apt, dnf...) telling it to
# install given packages. 
#
# Deletes the lock.
# 
# So far only apt supported
distro_package_manager_install() {
  create_package_manager_lock "$(caller)"
  feed_password_into_sudo apt install -y "$@"
  delete_package_manager_lock
}

# Call distro package manager (apt, dnf...) telling it to 
# uninstall given packages.
# Obtains a lock first.
# Tries to read sudo password from $DOTFILES_PASSWORD_FILE
# 
# So far only apt supported
distro_package_manager_uninstall() {
  create_package_manager_lock "$(caller)"
  feed_password_into_sudo apt remove -y "$@"
  delete_package_manager_lock
}

# Call distro package manager (apt, dnf...) telling it to
# update package list. I think this is not necessary for dnf.

# Obtains a lock first.
# Tries to read sudo password from $DOTFILES_PASSWORD_FILE
# 
# So far only apt supported
distro_package_manager_update() {
  create_package_manager_lock "$(caller)"
  feed_password_into_sudo apt update "$@"
  delete_package_manager_lock
}

# Must be called with "$(caller)"
#
# If $DOTFILES_PACKAGE_MANAGER_LOCK_DIR doesn't exist, then:
# - it gets created (this creates the lock).
# It writes $(caller) information to $DOTFILES_PACKAGE_MANAGER_LOCK_INFO_FILE (for debugging purposes).

# If it does exist it sleeps and tries again for predefined number of times until it succeeds or exits with fail message and code 2.
# $DOTFILES_TMP_DIR
# 
# Locking explanation: https://wiki.bash-hackers.org/howto/mutex
#
create_package_manager_lock() {
  for ((i=1; i<= DOTFILES_PACKAGE_MANAGER_LOCK_TRIES; i++)); do
    if mkdir "$DOTFILES_PACKAGE_MANAGER_LOCK_DIR" 2>/dev/null; then
      # lock successfuly created

      I_HAVE_CREATED_PACKAGE_MANAGER_LOCK=true
      echo "$@" > $DOTFILES_PACKAGE_MANAGER_LOCK_INFO_FILE
      success_msg "Package manager locked"
      return 0
    else

      # couldn't create lock
      local msg

      if [ ! -d "$DOTFILES_PACKAGE_MANAGER_LOCK_DIR" ]; then
        # directory doesn't exist, probably lock was just released
        msg="couldn't create lock but lock isn't present anymore."
      elif [ -f "$DOTFILES_PACKAGE_MANAGER_LOCK_INFO_FILE" ]; then
        msg="package manager locked by line $(cat $DOTFILES_PACKAGE_MANAGER_LOCK_INFO_FILE)"
      else
        msg="package manager is locked but I don't know who locked it"
      fi
      info_msg "Try $i / $DOTFILES_PACKAGE_MANAGER_LOCK_TRIES: $msg"

      sleep $DOTFILES_PACKAGE_MANAGER_LOCK_SLEEP_BETWEEN_TRIES

    fi
  done

  fail_msg "Couldn't create package manager lock\n(directory: $DOTFILES_PACKAGE_MANAGER_LOCK_DIR)"
  exit 2
}

# Deletes $DOTFILES_PACKAGE_MANAGER_LOCK_DIR and 
#         $DOTFILES_PACKAGE_MANAGER_LOCK_INFO_FILE
delete_package_manager_lock() {
  # [ -v var_name ] - is variable var_name defined
  if [ -v I_HAVE_CREATED_PACKAGE_MANAGER_LOCK ]; then
    rm $DOTFILES_PACKAGE_MANAGER_LOCK_INFO_FILE
    rmdir $DOTFILES_PACKAGE_MANAGER_LOCK_DIR
    success_msg "Package manager unlocked"
  fi
}

info_msg () {
  printf "\n\r  [ \033[00;34m..\033[0m ] $1\n"
}

success_msg () {
  printf "\n\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail_msg () {
  printf "\n\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n" >&2
}

fail_msg_and_exit () {
  fail_msg "$1\n"
  exit 1
}

report_error_and_exit() {
  fail_msg_and_exit "Error detected on line $(caller)"
}

# Print error message in case of error (any command returns non zero)
trap "delete_package_manager_lock; report_error_and_exit" ERR

# Print error message in case of interrupt
trap "delete_package_manager_lock; fail_msg_and_exit 'Installation interrupted!'" INT TERM
