#!/usr/bin/env sh

if [ -d /etc/X11/xinit/xinitrc.d ]; then
	for f in /etc/X11/xinit/xinitrc.d/*; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

if [ -f "$XDG_CONFIG_HOME/X11/Xresources" ]; then
	xrdb -merge "$XDG_CONFIG_HOME/X11/Xresources"
fi
. $XDG_BIN_HOME/env-xresources.sh
