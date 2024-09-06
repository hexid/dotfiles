#!/usr/bin/env sh

WAYBAR_SIGNAL=1

clear_notifications() {
	makoctl dismiss -a
}

show_mode() {
	local MODE="$(makoctl mode)"

	if [[ "$MODE" == 'dnd' ]]; then
		printf '{"text":"%s"}\n' ""
	else
		printf '{"text":"%s","class":"activated"}\n' ""
	fi
}

toggle_mode() {
	local MODE="$(makoctl mode)"

	if [[ "$MODE" == 'dnd' ]]; then
		makoctl mode -s "$1"
	else
		makoctl mode -s 'dnd'
	fi
	pkill -RTMIN+${WAYBAR_SIGNAL} -x waybar
}

case "$1" in
	--clear) clear_notifications ;;
	--show) show_mode ;;
	--toggle) toggle_mode "${2:-default}" ;;
esac
