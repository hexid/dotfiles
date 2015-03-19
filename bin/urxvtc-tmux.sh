#!/usr/bin/env bash

ID="$(tmux list-sessions | grep -vm1 attached | cut -d: -f1)"
if [[ -z "$ID" ]]; then
	urxvtc -e tmux new-session
else
	urxvtc -e tmux attach-session -t "$ID"
fi
