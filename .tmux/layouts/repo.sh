#!/bin/bash
# Repo-layout
# ===========
# The layout is a simple split in half.
#
# Argument 1 = Window name (reuse same windows on -1)
# Argument 2 = Path to repo


if [ "$#" -lt 2 ] || [ "$#" -gt 2 ]; then
    echo "Wrong number of arguments!" >&2
    exit 1
fi

[[ $1 != -1 ]] && tmux new-window -n "$1" -c "$2"

tmux splitw -h -p 50

tmux send-keys -t 1 "cd $2" C-j
tmux send-keys -t 2 "cd $2" C-j
