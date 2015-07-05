#!/usr/bin/env sh

repo=$(checkupdates | wc -l)
aur=$(pacaur -k | wc -l)

if [ $aur -ne 0 ]; then
	auru=" (+$aur)"
fi

herbstclient emit_hook updates "$repo$auru"
