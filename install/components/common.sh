#! /bin/bash

# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
# -x option causes bash to print each command before executing it
# which is useful for debugging
set -Euo pipefail

DOTFILES_DIR_ABS="$(dirname "$(dirname "$(dirname "$(readlink -f "$BASH_SOURCE")")")")"
DOTFILES_DIR_REL_FROM_HOME=${DOTFILES_DIR_ABS#"$HOME/"}

echo "DOTFILES_DIR_ABS = $DOTFILES_DIR_ABS"
echo "DOTFILES_DIR_REL_FROM_HOME = $DOTFILES_DIR_REL_FROM_HOME"

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

# check to see if command is installed (and is in $PATH)
command_exists()
{
  command -v "$1" >/dev/null 2>&1
}

report_error_and_exit() {
  fail_msg_and_exit "Error detected on line $(caller)"
}

# Print error message in case of error (any command returns non zero)
trap report_error_and_exit ERR

# Print error message in case of interrupt
trap "fail_msg_and_exit 'Installation interrupted!'" INT TERM
