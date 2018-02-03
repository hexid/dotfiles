#!/usr/bin/env sh

trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT

dir="$(cd "$(dirname "$0")" && pwd)"

hc="${herbstclient_command[@]:-herbstclient}"
monitor="${1:-0}"
geometry="$($hc monitor_rect "$monitor")"
if [ -z "$geometry" ]; then
	printf "Invalid monitor %s" "$monitor"
	exit 1
fi # geometry has the format X Y W H
read -r off_x off_y win_w win_h <<< "$geometry"
pan_h=30
pan_w="$win_w"
pan_off=1

textfont="${_xrdb_font}"
iconfont="${_xrdb_iconfont}"

active_color="$($hc attr theme.color)" # active text
backgd_color="$($hc attr theme.background_color)" # default fg/bg
normal_color="$($hc attr theme.normal.color)" # normal text
select_color="$($hc attr theme.active.color)" # selected tag bg
urgent_color="$($hc attr theme.urgent.color)" # urgent tag bg

panel_fifo="${XDG_RUNTIME_DIR:-/tmp}/hlwm_panel_${monitor}"

[ -e "$panel_fifo" ] && rm "$panel_fifo"
mkfifo "$panel_fifo"

printf_fifo() {
	printf "$@" >"$panel_fifo"
}

"$hc" pad "$monitor" "$pan_h"

bat="BAT1"
bat_dir="/sys/class/power_supply/$bat"
if [ -r "${bat_dir}" ]; then
	while true; do
		printf_fifo "battery\t%s\n" "$(($(cat "${bat_dir}"/energy_now) * 100 / $(cat "${bat_dir}"/energy_full)))"

		sleep 30
	done &
fi

while true; do
	printf_fifo "date\n"

	sleep 30
done &

# watch for herbstluft hooks
"$hc" --idle >"$panel_fifo" &

# watch for network changes
inotifywait -mq -e close_write --format 'network' /run/systemd/netif/ >"$panel_fifo" &

# write out initial panel info
printf_fifo 'keyboard\t%s\n' "$(keyboard-layout.sh -q)" &
printf_fifo 'tag_init\n' &
printf_fifo 'network\n' &
printf_fifo 'volume\n' &

"$dir"/panel_bar.sh "$monitor" <"$panel_fifo" | lemonbar -g "${pan_w}x${pan_h}+${off_x}+0" -o "${pan_off}" \
	-B "${backgd_color}" -F "${backgd_color}" -f "${textfont}" -f "${iconfont}" -a 50 | \
while read line; do
	IFS=$'\t' read -ra cmd <<<"${line}"
	case "${cmd[0]}" in
		keyboard) printf_fifo "keyboard\t%s\n" "$(keyboard-layout.sh)" & ;;
		status) printf_fifo "status\t%s\n" "${cmd[@]:1}" & ;;
		tag_focus) "$hc" chain . focus_monitor "$monitor" . use "${cmd[@]:1}" ;;
		tag_move) "$hc" chain . lock . move "${cmd[@]:1}" . focus_monitor "$monitor" . use "${cmd[@]:1}" . unlock ;;
		tag_swap) hlwm-swaptag.sh use "${cmd[@]:1}" ;;
		volume) volume-adjust.sh "${cmd[@]:1}" ;;
		*) printf_fifo "status\t%s\n" "${cmd[@]}" & ;;
	esac
done
