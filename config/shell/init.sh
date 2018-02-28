#!/bin/sh

if [ "$TERM" = "linux" ]; then # fix colors on TTYs
	cpp "$XDG_CONFIG_HOME"/X11/Xresources | sed '/\s*!/d' | \
		awk 'match($0, /\.color([0-9]+)\s*:\s*#(.*?)\s*/, a) && a[1] < 16 {printf "\\\\033]P%X%s", a[1], a[2]}' | \
		xargs printf '%b'
	clear
elif [[ "$(systemd-detect-virt)" = 'systemd-nspawn' ]]; then
	export TERM='screen-256color'
elif [[ -z "$TMUX" ]] && command -v tmux >/dev/null 2>&1; then # don't open tmux on TTYs
	TMUX_ID="$(tmux list-sessions | grep -vm1 attached | cut -d: -f1)"
	if [[ -z "$TMUX_ID" ]]; then
		exec tmux -f "$XDG_CONFIG_HOME"/tmux/tmux.conf new-session
	else
		exec tmux -f "$XDG_CONFIG_HOME"/tmux/tmux.conf attach-session -t "$TMUX_ID"
	fi
fi
