#!/usr/bin/env sh

id="$(xwininfo | grep 'Window id:' | grep -o '0x[0-9a-fA-F]*')"

data="$(xprop -id "$id")"

if printf '%s' "$data" | grep '_NET_WM_WINDOW_TYPE(ATOM) = _NET_WM_WINDOW_TYPE_TOOLTIP'; then
	xdotool windowunmap "$id"
else
	printf 'Window %s is not a tooltip\n' "$id"
fi
