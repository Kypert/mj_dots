#!/bin/bash
# Create the basic tmux structure, used after a change-weekend
# Simply run following to attach:
#     tmux $TMUX_ADDITIONAL_OPTS attach -t misc

# Repos
tmux $TMUX_ADDITIONAL_OPTS new-session -s lol -d
~/.tmux/layouts/repohome.sh -1 lol

# Simple
tmux $TMUX_ADDITIONAL_OPTS new-session -s misc -d -c ~
