#! /bin/bash

# load common.sh if it isn't loaded
[ -z "$DOTFILES_DIR_ABS" ] && source "$(dirname "$0")/common.sh"

LAB_DIR="$HOME/lab"
OLD_WORKING_DIRECTORY="$(pwd)"

# install rails prerequisites
info_msg "Installing rails prerequisites: nodejs and dev packages for sql-lite and PostgreSQL\n"
sudo apt install -y nodejs libsqlite3-dev libpq-dev
success_msg "Install rails prerequisites: nodejs and dev packages for sql-lite and PostgreSQL\n"

# https://classic.yarnpkg.com/en/docs/install/#debian-stable
info_msg "Installing rails prerequisites: yarn"

curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt remove -y cmdtest
sudo apt update
sudo apt install -y yarn

success_msg "Installing rails prerequisites: yarn"

# install rails
info_msg "Installing rails\n"

gem install rails

if ! command_exists rails; then
 fail_msg_and_exit "Install rails"
fi

success_msg "Install rails"

# create test app

rails_test_app="dotfiles_test_app"
info_msg "Creating test app in $LAB_DIR/$rails_test_app\n"

mkdir -p "$LAB_DIR"
cd "$LAB_DIR"
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

info_msg "Please check everything is working by running:\ncd $LAB_DIR/$rails_test_app\nrails server"
