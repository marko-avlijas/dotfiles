#! /bin/bash

# load script/lib/all.sh if it isn't loaded
[ -z "$DOTFILES_DIR_ABS" ] && source "$(dirname "$(dirname "$BASH_SOURCE")")/lib/all.sh"


# install rails
info_msg "Installing rails\n"

gem install rails

if ! command_exists rails; then
 fail_msg_and_exit "Install rails"
fi

success_msg "Install rails"

# create test app

rails_test_app="dotfiles_test_app"
info_msg "Creating test app in $DOTFILES_LAB_DIR/$rails_test_app\n"

mkdir -p "$DOTFILES_LAB_DIR"
cd "$DOTFILES_LAB_DIR"
rm -rf "$rails_test_app"
rails new "$rails_test_app"
cd "$rails_test_app"

# fix bug Rails generate error: No such file or directory - getcwd
# in case this script has been run before 
spring stop

bundle install
rails g scaffold Post title body:text
rails db:migrate
rails test
cd "$OLD_WORKING_DIRECTORY"

success_msg "Install rails"
