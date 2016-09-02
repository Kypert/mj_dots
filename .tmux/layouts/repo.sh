#!/bin/bash
# Repo-layout
# ===========
# The layout is a simple split in half.
# Since the repo might be located in a different host, there is an option to also specify the host
#
# Argument 1 = Window name (reuse same windows on -1)
# Argument 2 = Repo name (assume /workspace/git/<user>/<repo>)
# Argument 3 = Optional ssh to git-ts, e.g. the ssr-repo


if [ "$#" -lt 2 ] || [ "$#" -gt 3 ]; then
  echo "Wrong number of arguments!" >&2
  exit 1
fi

[[ $1 != -1 ]] && tmux $TMUX_ADDITIONAL_OPTS new-window -n $1 -c /workspace/git/$USER/$2

tmux $TMUX_ADDITIONAL_OPTS splitw -h -p 50

if [ "$#" -eq 3 ]; then
    tmux $TMUX_ADDITIONAL_OPTS send-keys -t 1 "sshh $3" C-j
    tmux $TMUX_ADDITIONAL_OPTS send-keys -t 2 "sshh $3" C-j
fi

tmux $TMUX_ADDITIONAL_OPTS send-keys -t 1 "zsh" C-j
tmux $TMUX_ADDITIONAL_OPTS send-keys -t 1 "cd /workspace/git/$USER/$2" C-j
tmux $TMUX_ADDITIONAL_OPTS send-keys -t 2 "cd /workspace/git/$USER/$2" C-j
