#! /bin/bash

TMUX_SESSION="Step 2"
components_dir="$(dirname "$BASH_SOURCE")/components"
tmux_steps_dir="$(dirname "$BASH_SOURCE")/tmux_steps"

# start new tmux session named "$TMUX_SESSION"
tmux new-session -d -s "$TMUX_SESSION"

tmux rename-window "Step 2" 

tmux send-keys "$components_dir/create_ssh_keys.sh" Enter

# create right pane
tmux split-window -h
tmux select-pane -t 2
tmux send-keys "$tmux_steps_dir/step_2_right_pane_actions.sh" Enter

tmux attach-session -t "$TMUX_SESSION"
