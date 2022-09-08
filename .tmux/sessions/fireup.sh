#!/bin/bash
# Create the basic tmux structure, used after a reboot
# Simply run following to attach:
#     tmux $TMUX_ADDITIONAL_OPTS attach -t main

# Make sure we have /tmp/$USER since that is where I will put things...
mkdir -p "/tmp/$USER"

# Repos
tmux new-session -s main -d
~/.tmux/layouts/repo.sh -1 "/home/$USER/proj/"

# Nodes
tmux new-session -s node -d
~/.tmux/layouts/node.sh -1

# Simple
tmux new-session -s misc -d -c "$HOME"
