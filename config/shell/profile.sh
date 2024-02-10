#!/usr/bin/env sh

set -- ~/.config/shell/profile.d/*

for f in "$@"; do
	. "$f"
done

[ -e "$XDG_CONFIG_HOME"/dircolors ] && eval $(dircolors -b "$XDG_CONFIG_HOME"/dircolors) || eval $(dircolors -b)
