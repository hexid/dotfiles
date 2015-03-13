#!/usr/bin/env bash

# returns 0 if a line without attached was found
tmux list-sessions | grep -vq attached

if [ $? -eq 0 ]; then
	urxvtc -e tmux attach-session
else
	urxvtc -e tmux new-session
fi
