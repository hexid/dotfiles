#!/usr/bin/env bash

if pidof mpd; then
	case "$1" in
		play)
			mpc toggle
			;;
		prev | next)
			mpc "$1"
			;;
	esac
fi
