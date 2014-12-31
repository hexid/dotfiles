#!/usr/bin/env sh

if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/Xresources" ]; then
  xrdb -merge "${XDG_CONFIG_HOME:-$HOME/.config}/Xresources"
fi

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

exec herbstluftwm
