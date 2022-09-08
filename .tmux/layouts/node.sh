#!/bin/bash
# Node-layout
# ===========
# The layout is basically split in half, with the node to the right.
#
# Argument 1 = Window name (reuse same windows on -1)

if [ "$#" -lt 1 ] || [ "$#" -gt 1 ]; then
    echo "Wrong number of arguments!" >&2
    exit 1
fi

TMUX_CMD="tmux"

[[ $1 != -1 ]] && $TMUX_CMD new-window -n "$1"

$TMUX_CMD splitw -h -p 50

# Now work on the left side
$TMUX_CMD selectp -t 1

# Create a small pane at the top
$TMUX_CMD splitw -v -p 90

# Then just split the rest
$TMUX_CMD splitw -v -p 50

$TMUX_CMD send-keys -t 1 "fish" C-j
$TMUX_CMD send-keys -t 2 "fish" C-j
$TMUX_CMD send-keys -t 3 "fish" C-j
$TMUX_CMD send-keys -t 4 "fish" C-j
