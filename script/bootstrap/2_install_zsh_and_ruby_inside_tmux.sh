#! /bin/bash

# load script/lib/all.sh if it isn't loaded
[ -z "$DOTFILES_DIR_ABS" ] && source "$(dirname "$(dirname "$BASH_SOURCE")")/lib/all.sh"

TMUX_SESSION="Step 2"

read_sudo_password_and_save_it_in_tmp_file

# start new tmux session named "$TMUX_SESSION"
tmux new-session -d -s "$TMUX_SESSION"

tmux rename-window "Step 2" 

tmux send-keys "$DOTFILES_INSTALL_DIR/install_ruby_using_ruby_install_and_chruby.sh" Enter

# create right pane
tmux split-window -h
tmux select-pane -t 2
install_zsh_command="$DOTFILES_INSTALL_DIR/install_zsh.sh && $DOTFILES_INSTALL_DIR/install_oh_my_zsh.sh && $DOTFILES_INSTALL_DIR/configure_zsh.sh"
tmux send-keys "$install_zsh_command" Enter

tmux attach-session -t "$TMUX_SESSION"

delete_sudo_password
