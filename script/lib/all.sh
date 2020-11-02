#! /bin/bash

# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -Euo pipefail

# -x option causes bash to print each command before executing it
# which is useful for debugging
# you can set it anywhere in file like this
# set -x

DOTFILES_DIR_ABS="$HOME/dotfiles"
DOTFILES_DIR_REL_FROM_HOME="${DOTFILES_DIR_ABS#"$HOME/"}"
DOTFILES_SRC_DIR="$HOME/src" # directory for cloning git repos
DOTFILES_LAB_DIR="$HOME/lab" # directory for quick tests

DOTFILES_INSTALL_DIR="$DOTFILES_DIR_ABS/script/install"
DOTFILES_CONFIGURE_DIR="$DOTFILES_DIR_ABS/script/configure"
DOTFILES_BOOTSTRAP_DIR="$DOTFILES_DIR_ABS/script/bootstrap"

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

# Asks for sudo password and saves it in $DOTFILES_PASSWORD_FILE
read_sudo_password_and_save_it_in_tmp_file() {
  read -s -p "Please enter sudo password: "
  echo "$REPLY" > "$DOTFILES_PASSWORD_FILE"
  info_msg "Temporarily saved password to $DOTFILES_PASSWORD_FILE"
}

# Delete file containing sudo password
delete_sudo_password() {
  rm -v "$DOTFILES_PASSWORD_FILE"
  info_msg "Deleted temporarily saved password in $DOTFILES_PASSWORD_FILE"
}

# If $DOTFILES_PASSWORD_FILE exists it feeds it to sudo
# using sudo's --stdin option.
# Otherwise it just performs sudo with given arguments
# and user has to type the sudo password.
feed_password_into_sudo() {
  # "$@" means expand all parameters just like they were sent
  set -x # bash be verbose
  if [ -f $DOTFILES_PASSWORD_FILE ]; then
    cat "$DOTFILES_PASSWORD_FILE" | sudo --stdin "$@"
  else
    sudo "$@"
  fi
  set +x # bash stop being verbose
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
# Summary: checking if file exists and creating it are 2 steps.
# It's not an atomic operation and race conditions can occur.
# Creating a directory is atomic.

# There is a big difference between mkdir and mkdir -p.
# mkdir will throw an error if directory already exists.
# mkdir -p will not throw an error.
# That's why mkdir must create lock directory without -p flag.
create_package_manager_lock() {
  mkdir -p $DOTFILES_TMP_DIR # with -p so it doesn't fail if directory exists
  last_package_manager_lock_message=""

  for ((i=1; i<= DOTFILES_PACKAGE_MANAGER_LOCK_TRIES; i++)); do
    if mkdir "$DOTFILES_PACKAGE_MANAGER_LOCK_DIR" 2>/dev/null; then
      # lock successfuly created

      I_HAVE_CREATED_PACKAGE_MANAGER_LOCK="true"
      echo "$@" > $DOTFILES_PACKAGE_MANAGER_LOCK_INFO_FILE
      success_msg "Package manager locked"
      return 0
    else

      # couldn't create lock
      set_package_manager_lock_busy_explanation_msg

      report_lock_wait_lock_progress $i $DOTFILES_PACKAGE_MANAGER_LOCK_TRIES \
                                     "$package_manager_lock_busy_explanation_msg"
                                   
      sleep $DOTFILES_PACKAGE_MANAGER_LOCK_SLEEP_BETWEEN_TRIES

    fi
  done

  fail_msg "Couldn't create package manager lock\n(directory: $DOTFILES_PACKAGE_MANAGER_LOCK_DIR)"
  exit 2
}

set_package_manager_lock_busy_explanation_msg() {
  if [ ! -d "$DOTFILES_PACKAGE_MANAGER_LOCK_DIR" ]; then
    # directory doesn't exist, probably lock was just released
    package_manager_lock_busy_explanation_msg="couldn't create lock but lock isn't present anymore."
  elif [ -f "$DOTFILES_PACKAGE_MANAGER_LOCK_INFO_FILE" ]; then
    package_manager_lock_busy_explanation_msg="package manager locked by line $(cat $DOTFILES_PACKAGE_MANAGER_LOCK_INFO_FILE)"
  else
    package_manager_lock_busy_explanation_msg="package manager is locked but I don't know who locked it"
  fi
}

# Usage:
# report_lock_waiting_progress(1 300 "package manager locked by ...")
# current_try == 1
# total_tries == 300 
# info_message

# prints something like:
# Try 1 / 300: info_message
#
# if message is same then just print current try without new line
# Try 2 / 300
#
# if message is still same it erases last line (Try 2 / 300) and replaces it with:
# Try 3 /300
#
# If message changes then prints new line and new message.
# Try 4 / 300: other message
#
report_lock_wait_lock_progress() {
  local current_try=$1
  local max_tries=$2
  local msg=$3

  local tries="Try $current_try / $max_tries"
  local full_message="$tries: $msg"
  if [[ $msg != $last_package_manager_lock_message ]]; then
    # message has changed, print in new line
    info_msg "$full_message"
  else
    # message stayed the same
    echo -en "\033[2K"  # clear everything on current line
    info_msg_in_same_line "$tries" # just print current try
  fi

  last_package_manager_lock_message=$msg
}

# Deletes $DOTFILES_PACKAGE_MANAGER_LOCK_DIR and 
#         $DOTFILES_PACKAGE_MANAGER_LOCK_INFO_FILE
delete_package_manager_lock() {
  # [ -v var_name ] - is variable var_name defined works in bash >= 4.0
  if [ -n I_HAVE_CREATED_PACKAGE_MANAGER_LOCK ]; then
    rm $DOTFILES_PACKAGE_MANAGER_LOCK_INFO_FILE
    rmdir $DOTFILES_PACKAGE_MANAGER_LOCK_DIR
    unset I_HAVE_CREATED_PACKAGE_MANAGER_LOCK
    success_msg "Package manager unlocked"
  fi
}

info_msg () {
  printf "\n\r  [ \033[00;34m..\033[0m ] $1\n"
}

info_msg_in_same_line () {
  printf "\r  [ \033[00;34m..\033[0m ] $1"
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
