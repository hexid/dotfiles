#!/usr/bin/env bash

if pidof mpv; then
	case "$1" in
		play)
			echo "cycle pause" > "$XDG_CONFIG_HOME/mpv/fifo"
			;;
		prev)
			echo "playlist_prev" > "$XDG_CONFIG_HOME/mpv/fifo"
			;;
		next)
			echo "playlist_next" > "$XDG_CONFIG_HOME/mpv/fifo"
			;;
	esac
fi
