#!/usr/bin/env sh

for f in "${XDG_CONFIG_HOME:-$HOME/.config}/shell/profile.d/"*; do
	. "$f"
done

[ -e "$XDG_CONFIG_HOME"/dircolors ] && eval $(dircolors -b "$XDG_CONFIG_HOME"/dircolors) || eval $(dircolors -b)
