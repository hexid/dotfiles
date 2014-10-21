#!/usr/bin/env sh
# Toggle external monitor

IN='LVDS1'
EXT='HDMI1'

if (xrandr | grep -q "$EXT connected [[:digit:]]\+x[[:digit:]]\++[[:digit:]]\++[[:digit:]]\+"); then
	xrandr --output $IN --auto --output $EXT --off
else
	xrandr --output $IN --auto --primary --output $EXT --auto --right-of $IN
fi

herbstclient reload
