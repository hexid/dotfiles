#!/usr/bin/env sh

case "$1" in
	down)
		amixer -q -D pulse sset Master 5%-
		;;
	up)
		amixer -q -D pulse sset Master 5%+
		;;
	mute)
		amixer -q -D pulse set Master Playback Switch toggle
		;;
esac
herbstclient emit_hook volume
