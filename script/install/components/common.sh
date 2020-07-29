#! /bin/bash

# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
# -x option causes bash to print each command before executing it
# which is useful for debugging
set -Euo pipefail

DOTFILES_DIR_ABS="$(dirname "$(dirname "$(dirname "$(readlink -f "$BASH_SOURCE")")")")"
DOTFILES_DIR_REL_FROM_HOME=${DOTFILES_DIR_ABS#"$HOME/"}
DOTFILES_SRC_DIR="$HOME/src" # directory for cloning git repos
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
trap report_error_and_exit ERR

# Print error message in case of interrupt
trap "fail_msg_and_exit 'Installation interrupted!'" INT TERM
