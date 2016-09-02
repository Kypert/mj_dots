#!/bin/bash
# Node-layout
# ===========
# The layout is basically split in half, with the node to the right. To the left is the booking, tool and lab.
# By default, this layout will be created with an empty template, but it is possible to select a specific node
# and get pre-defined input.
#
# Argument 1 = Window name (reuse same windows on -1)
# Argument 2 = Optional node name (e.g epg123-3)

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
  echo "Wrong number of arguments!" >&2
  exit 1
fi

[[ $1 != -1 ]] && tmux $TMUX_ADDITIONAL_OPTS new-window -n $1

tmux $TMUX_ADDITIONAL_OPTS splitw -h -p 50

# Now work on the left side
tmux $TMUX_ADDITIONAL_OPTS selectp -t 1

# Create a small pane at the top
tmux $TMUX_ADDITIONAL_OPTS splitw -v -p 90

# Then just split the rest
tmux $TMUX_ADDITIONAL_OPTS splitw -v -p 50

# Go to the lab
tmux $TMUX_ADDITIONAL_OPTS send-keys -t 1 "sshl" C-j
tmux $TMUX_ADDITIONAL_OPTS send-keys -t 2 "sshl" C-j
tmux $TMUX_ADDITIONAL_OPTS send-keys -t 3 "sshl" C-j
tmux $TMUX_ADDITIONAL_OPTS send-keys -t 4 "sshl" C-j

# Prepare the booking
tmux $TMUX_ADDITIONAL_OPTS send-keys -t 1 "/lab/epg_design_utils/stratos/lockNode -f -s "

if [ "$#" -eq 2 ]; then
    # Prepare the booking, finally with the name
    tmux $TMUX_ADDITIONAL_OPTS send-keys -t 1 "$2"

    # Prepare the tool, only supports the normal epgtoolXXX-Y0
    TOOL=$2
    TOOL=${TOOL/epg/epgtool}0
    tmux $TMUX_ADDITIONAL_OPTS send-keys -t 2 "sshh $TOOL" C-j

    # Prepare the node
    tmux $TMUX_ADDITIONAL_OPTS send-keys -t 4 "sshh $2" C-j
else
    # Prepare the tool with the template
    tmux $TMUX_ADDITIONAL_OPTS send-keys -t 2 "ssh epgtool"
fi
