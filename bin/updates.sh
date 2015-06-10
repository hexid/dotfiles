#!/usr/bin/env bash

let repo=$(checkupdates | wc -l)
let aur=$(pacaur -k | wc -l)

if [ $aur -ne 0 ]; then
	auru=" (+$aur)"
fi

herbstclient emit_hook updates "$repo$auru"
