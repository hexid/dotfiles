#!/usr/bin/env bash

if pidof pianobar; then
	case "$1" in
		play)
			echo "p" > "$XDG_CONFIG_HOME/pianobar/ctl"
			;;
		prev)
			;;
		next)
			echo "n" > "$XDG_CONFIG_HOME/pianobar/ctl"
			;;
	esac
fi
