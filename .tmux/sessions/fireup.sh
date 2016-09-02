#!/bin/bash
# Create the basic tmux structure, used after a change-weekend
# Simply run following to attach:
#     tmux $TMUX_ADDITIONAL_OPTS attach -t main

# Repos
tmux $TMUX_ADDITIONAL_OPTS new-session -s main -d
~/.tmux/layouts/repo.sh -1 main
tmux $TMUX_ADDITIONAL_OPTS new-session -s tr -d
~/.tmux/layouts/repo.sh -1 tr
tmux $TMUX_ADDITIONAL_OPTS new-session -s proto -d
~/.tmux/layouts/repo.sh -1 proto
tmux $TMUX_ADDITIONAL_OPTS new-session -s team_stratos -d
~/.tmux/layouts/repo.sh -1 team_stratos
tmux $TMUX_ADDITIONAL_OPTS new-session -s ssr -d
~/.tmux/layouts/repo.sh -1 ssr_repo eselnts1251

# Nodes
tmux $TMUX_ADDITIONAL_OPTS new-session -s node -d
~/.tmux/layouts/node.sh -1

# Simple
tmux $TMUX_ADDITIONAL_OPTS new-session -s misc -d -c /lab/epg_ssr_sdk
tmux $TMUX_ADDITIONAL_OPTS new-session -s golf -d -c /home/emajons/vim_golf
