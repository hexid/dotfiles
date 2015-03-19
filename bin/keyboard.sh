#!/usr/bin/env bash

# Emulates a keyboard
# Requires `xdotool`

# args:

if [ $# -lt 1 ]; then
	echo "Invalid arguments"
	echo "args: $(basename $0) command [commandArgs]"
	exit 1
fi

function cmd_herbstluftwm() {
	return;
}

function sendkey() {
	DISPLAY=:0 xdotool key $@
	sleep 1
}
function sendtext() {
	DISPLAY=:0 xdotool type $@
	sleep 1
}

cmd=$1
shift

case $cmd in
	"dmenu")
		sendkey "Super+d"
		sendtext "$@"
		sendkey "Return"
		;;
	"herb")
		;;
	"key")
		sendkey "$@"
		;;
esac