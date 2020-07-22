#! /bin/bash

# load common.sh if it isn't loaded
[ -z "$DOTFILES_DIR_ABS" ] && source "$(dirname "$0")/common.sh"

DOTFILES_SRC_DIR="$HOME/src"

# returns true if chruby is installed
chruby_installed() {
  [ -f "/usr/local/share/chruby/chruby.sh" ] # does this file exist and is it a file
}

# appends 2 lines to shell file (.bashrc or .zshrc - $1 - first parametar)
# only adds them if they do not already exist in the given file
append_chruby_to_shell_rc_file() {
  shell_file=$1
  CHRUBY_APPEND_CHRUBY_SH="source /usr/local/share/chruby/chruby.sh"
  CHRUBY_APPEND_AUTO_SH="source /usr/local/share/chruby/auto.sh"

  if grep "$CHRUBY_APPEND_CHRUBY_SH" $shell_file > /dev/null; then 
    info_msg "chruby already added to $shell_file - skipping\n"
  else
    info_msg "Adding chruby to $shell_file\n"
    cat >> $shell_file <<EOF
$CHRUBY_APPEND_CHRUBY_SH
$CHRUBY_APPEND_AUTO_SH
EOF
  success_msg "Added chruby to $shell_file"
  fi
}

# install ruby & rails prerequisites
info_msg "Installing ruby prerequisites\n"
sudo apt install -y build-essential
success_msg "Install ruby prerequisites"

# create directory $DOTFILES_SRC_DIR if it doesn't exist and enter it
[ -d "$DOTFILES_SRC_DIR" ] || mkdir "$DOTFILES_SRC_DIR"
cd "$DOTFILES_SRC_DIR"

# install ruby-install
if command_exists ruby-install; then
  info_msg "ruby-install already installed - skipping"
else
  info_msg "Installing ruby-install\n"

  # install by cloning git repo
  # instead of following instructions from README (because they change for each version just because of version number)
  git clone "https://github.com/postmodern/ruby-install"
  cd ruby-install
  sudo make install

  if ! command_exists ruby-install; then
   fail_msg_and_exit "Installed ruby-install"
  fi

  success_msg "Install ruby-install\n"
fi

# install latest stable ruby version
# ruby-install ruby

# install chruby
if chruby_installed; then
  info_msg "chruby already installed - skipping"
else
  info_msg "Installing chruby\n"

  # install by cloning git repo
  # instead of following instructions from README (because they change for each version just because of version number)
  cd "$DOTFILES_SRC_DIR"
  git clone "https://github.com/postmodern/chruby"
  cd chruby
  # sudo make install     # this doesn't work for some reason
  sudo ./scripts/setup.sh # this is alternative from chruby's README

  if ! chruby_installed; then
   fail_msg_and_exit "Install chruby"
  fi

  success_msg "Install chruby"
fi

# add chruby.sh and auto.sh to .zshrc
# auto.sh automatically changes ruby version when you cd into directory with different .ruby-version file
append_chruby_to_shell_rc_file "$HOME/.bashrc"
append_chruby_to_shell_rc_file "$HOME/.zshrc"
