#!/usr/bin/env bash

ID="$(tmux list-sessions | grep -vm1 attached | cut -d: -f1)"
if [[ -z "$ID" ]]; then
	urxvtc -e tmux -f $XDG_CONFIG_HOME/tmux/tmux.conf new-session
else
	urxvtc -e tmux -f $XDG_CONFIG_HOME/tmux/tmux.conf attach-session -t "$ID"
fi
