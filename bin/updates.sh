#!/usr/bin/env sh

repo=$(checkupdates | wc -l)
aur=$(pacaur -k --devel --needed | wc -l)

if [ $aur -ne 0 ]; then
	auru=" (+$aur)"
fi

printf "%s%s" "$repo" "$auru" > "${XDG_RUNTIME_DIR:-/tmp}/checkup-status"
herbstclient emit_hook updates
