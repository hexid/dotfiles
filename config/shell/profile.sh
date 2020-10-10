#!/usr/bin/env sh

[ -e "$XDG_CONFIG_HOME"/dircolors ] && eval $(dircolors -b "$XDG_CONFIG_HOME"/dircolors) || eval $(dircolors -b)
