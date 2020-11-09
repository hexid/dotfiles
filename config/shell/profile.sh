#!/usr/bin/env sh

DIR=`dirname "$(readlink -f "$0")"`

for f in "$DIR"/profile.d/*; do
	. "$f"
done

[ -e "$XDG_CONFIG_HOME"/dircolors ] && eval $(dircolors -b "$XDG_CONFIG_HOME"/dircolors) || eval $(dircolors -b)
