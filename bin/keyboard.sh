#!/usr/bin/env sh

# Emulates a keyboard
# Requires `xdotool`

# args:

if [ $# -lt 1 ]; then
	printf "Invalid arguments\nargs: %s command [commandArgs]\n" "$(basename $0)"
	exit 1
fi

cmd_herbstluftwm() {
	return;
}

sendkey() {
	DISPLAY=:0 xdotool key $@
	sleep 1
}
sendtext() {
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
