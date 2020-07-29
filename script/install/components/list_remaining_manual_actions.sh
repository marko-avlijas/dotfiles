#! /bin/bash

# load common.sh if it isn't loaded
[ -z "$DOTFILES_DIR_ABS" ] && source "$(dirname "$0")/common.sh"

info_msg "Manual steps remaining:\n"

cat <<EOF
  * remap CAPS LOCK to CTRL
  * add generated ssh keys to github and bitbucket
  * run $DOTFILES_DIR_ABS/color_test/24_bit_color_test.sh
  * install tmux plugins (press prefix + I inside tmux)
EOF
