#! /bin/bash

# Based on: https://github.com/Valloric/YouCompleteMe/wiki/Building-Vim-from-source
# and https://github.com/vim/vim/blob/master/src/Makefile

# load script/lib/all.sh if it isn't loaded
[ -z "$DOTFILES_DIR_ABS" ] && source "$(dirname "$(dirname "$BASH_SOURCE")")/lib/all.sh"

# remove existing vim
info_msg "Removing system vim"
distro_package_manager_uninstall vim \
                                 vim-runtime \
                                 gvim \
                                 vim-tiny \
                                 vim-common \
                                 vim-gui-common
success_msg "Remove system vim"

# return if vim is already installed
if command_exists vim; then
  info_msg "Vim already installed - skipping"
  exit 0 
fi

# install prerequisites
# seems there are no prerequisites for Ubuntu 20.04?
# info_msg "Installing vim prerequisites\n"
# distro_package_manager_install libncurses5-dev \
                               # libatk1.0-dev \
                               # libbonoboui2-dev \
                               # libcairo2-dev \
                               # libx11-dev \
                               # libxpm-dev \
                               # libxt-dev \
                               # python-dev
# success_msg "Install vim prerequisites"

# create directory $DOTFILES_SRC_DIR if it doesn't exist and enter it
mkdir -p "$DOTFILES_SRC_DIR"
cd "$DOTFILES_SRC_DIR"

# clone the repo or pull if it already exists
if [ -d "$DOTFILES_SRC_DIR/vim" ]; then
  info_msg "Pulling vim get repo to get latest changes"
  cd vim
  git pull
  success_msg "git pull"
else
  info_msg "Cloning vim git repo"
  git clone "https://github.com/vim/vim" --depth=1
  success_msg "Clone vim git repo"
  cd vim
fi

# delete results of old configure (in case this script is restarted)
info_msg "Cleaning old vim config"
make clean
success_msg "Clean old vim config"

# configure (again)
info_msg "Configuring vim"
./configure --with-features=huge \
            --disable-gui \
	    --disable-rightleft --disable-arabic \
            --prefix=/usr/local \
            --with-compiledby=Anon
            # --enable-python3interp=yes \
            # --with-python3-config-dir=$(python3-config --configdir) \
            # --enable-luainterp=yes \
success_msg "Configure vim"

# run tests
info_msg "Running vim tests"
make test
success_msg "vim tests"

# make install
info_msg "Running sudo make install"
make VIMRUNTIMEDIR=/usr/local/share/vim/vim82
sudo make install

if command_exists vim; then
  success_msg "Install vim"
else
  fail_msg_and_exit "Install vim"
fi

cd "$OLD_WORKING_DIRECTORY"
