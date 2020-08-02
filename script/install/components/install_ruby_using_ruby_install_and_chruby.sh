#! /bin/bash

# load common.sh if it isn't loaded
[ -z "$DOTFILES_DIR_ABS" ] && source "$(dirname "$0")/common.sh"

RUBIES_DIR="$HOME/.rubies"

# returns true if chruby is installed
chruby_installed() {
  [ -f "/usr/local/share/chruby/chruby.sh" ] # does this file exist and is it a file
}

# install ruby prerequisites
info_msg "Installing ruby prerequisites\n"
sudo apt install -y build-essential
success_msg "Install ruby prerequisites"

# create directory $DOTFILES_SRC_DIR if it doesn't exist and enter it
mkdir -p "$DOTFILES_SRC_DIR"
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
   fail_msg_and_exit "Install ruby-install"
  fi

  success_msg "Install ruby-install\n"
fi

# install latest stable ruby version
ruby-install ruby

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

cd "$OLD_WORKING_DIRECTORY"

# create .ruby-version in $HOME
installed_ruby=$(ls -1 "$RUBIES_DIR")
echo $installed_ruby
number_of_installed_rubies=$(echo "$installed_ruby" | wc -l)
if [ -z $installed_ruby ]; then
  fail_msg_and_exit "Expected to find 1 installed ruby in $RUBIES_DIR but found none. Can't create "$HOME/.ruby-version""
elif (( number_of_installed_rubies != 1 )); then
  fail_msg_and_exit "Expected to find 1 installed ruby in $RUBIES_DIR but found $number_of_installed_rubies.\n I don't know which one to set as default in "$HOME/.ruby-version""
else
  echo $installed_ruby > "$HOME/.ruby-version"
  success_msg "Set $installed_ruby in "$HOME/.ruby-version""
fi

gem install tmuxinator
