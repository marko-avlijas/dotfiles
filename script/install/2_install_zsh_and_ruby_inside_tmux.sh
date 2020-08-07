#! /bin/bash

# load common.sh if it's not loaded
[ -z "$DOTFILES_DIR_ABS" ] && source "$(dirname "$0")/components/common.sh"

TMUX_SESSION="Step 2"
components_dir="$DOTFILES_INSTALL_COMPONENTS_DIR"

read_sudo_password_and_save_it_in_tmp_file

# start new tmux session named "$TMUX_SESSION"
tmux new-session -d -s "$TMUX_SESSION"

tmux rename-window "Step 2" 

tmux send-keys "$components_dir/install_ruby_using_ruby_install_and_chruby.sh" Enter

# create right pane
tmux split-window -h
tmux select-pane -t 2
install_zsh_command="$components_dir/install_zsh.sh && $components_dir/install_oh_my_zsh.sh && $components_dir/configure_zsh.sh"
tmux send-keys "$install_zsh_command" Enter

tmux attach-session -t "$TMUX_SESSION"

delete_sudo_password
