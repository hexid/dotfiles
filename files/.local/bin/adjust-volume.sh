#!/usr/bin/env bash

case $1 in
    down)
         amixer -q -D pulse sset Master 5%-
         herbstclient emit_hook volume
         ;;
    up)
         amixer -q -D pulse sset Master 5%+
         herbstclient emit_hook volume
         ;;
    mute)
         amixer -q -D pulse set Master Playback Switch toggle
         herbstclient emit_hook volume
         ;;
esac
