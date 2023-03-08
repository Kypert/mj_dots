#!/bin/bash
# Create the basic tmux structure, used after a reboot
# Simply run following to attach:
#     tmux $TMUX_ADDITIONAL_OPTS attach -t main

# Make sure we have /tmp/$USER since that is where I will put things...
mkdir -p "/tmp/$USER"

# Repo#1
tmux new-session -s work1 -d
~/.tmux/layouts/repo.sh -1 "/home/$USER/proj/work"

# Repo#2
tmux new-session -s work2 -d
~/.tmux/layouts/repo.sh -1 "/home/$USER/proj/work"

# Connections
tmux new-session -s connections -d
tmux splitw -h -p 50
tmux send-keys -t 1 "cd /home/$USER/proj/work/ic-bastion/client_setup" C-j
tmux send-keys -t 1 "./start_tunnels.sh"
tmux send-keys -t 2 "sudo -i openconnect --user=$USER --protocol=nc https://access.stspc.ericsson.net/nix"

# Terminals
tmux new-session -s terminal -d
tmux rename-window dev
tmux send-keys "ssh terminal-dev"
tmux new-window -n ci-gate
tmux new-window -n stable

# Simple
tmux new-session -s home -d -c "$HOME"
