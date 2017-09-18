#!/bin/sh

if [ "$TERM" = "linux" ]; then # fix colors on TTYs
	_SEDCMD='s/.*\*color\([0-9]\{1,\}\).*#\([0-9a-fA-F]\{6\}\).*/\1 \2/p'
	for i in $(sed -n "$_SEDCMD" "$XDG_CONFIG_HOME"/X11/Xresources | \
				awk '$1 < 16 {printf "\\e]P%X%s", $1, $2}'); do
		printf "$i"
	done
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
