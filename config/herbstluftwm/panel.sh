#!/usr/bin/env bash

hc="${herbstclient_command[@]:-herbstclient}"
monitor=${1:-0}
geometry="$($hc monitor_rect $monitor)"
if [ -z "$geometry" ]; then
	printf "Invalid monitor %s" "$monitor"
	exit 1
fi # geometry has the format X Y W H
read -r off_x off_y win_w win_h <<< "$geometry"
pan_h=15
pan_w=$win_w

textfont="-*-fixed-medium-*-*-*-12-*-*-*-*-*-*-*"
iconfont="FontAwesome:size=8"
bat="BAT0"

active_color="$($hc attr theme.color)" # active text
backgd_color="$($hc attr theme.background_color)" # default fg/bg
normal_color="$($hc attr theme.normal.color)" # normal text
select_color="$($hc attr theme.active.color)" # selected tag bg
urgent_color="$($hc attr theme.urgent.color)" # urgent tag bg

sep="%{F$select_color}|"

uniq_linebuffered() {
	awk '$0 != l { print ; l=$0 ; fflush(); }' "$@"
}
print_color_dual() { # background foreground
	printf "%%{B%s}%%{F%s}" "$1" "$2"
}

battery_widget() {
	dir="/sys/class/power_supply/$bat"
	if [ -r $dir ]; then
		pwr="$(($(cat $dir/charge_now) * 100 / $(cat $dir/charge_full)))"
		printf "%s %%{F%s}%b %%{F%s}%s " "$sep" "$normal_color" "\uf24$((4 - ($pwr - 1) / 20))" "$active_color" "$pwr%"
	fi
}
date_widget() {
	date +"date\t$sep %{F$active_color}%-d %{F$normal_color}%b %Y %{F$active_color}%H:%M "
}
network_widget() {
	addr="$(ip addr | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2 /p' | tr -d '\n')"
	adapter="$(cat /sys/class/net/bond0/bonding/active_slave)"
	printf "network\t%s %%{F%s}%b %%{F%s}%b " "$sep" "$normal_color" '\uf1eb' "$active_color" \
		"$([[ -z "$addr" ]] && printf 'None' || printf '%s%s' "$addr" "$adapter")"
}
updates_widget() {
	file="${XDG_RUNTIME_DIR:-/tmp}/checkup-status"
	if [ -r $file ]; then
		upd="$(cat $file)"
		if [[ "$upd" != "0" ]]; then
			printf "%s %s%b %s%s " "$sep" "%{F$normal_color}" '\uf062' "%{F$active_color}" "$upd"
		fi
	fi
}
volume_widget() {
	printf "%s%s %%{F%s}%b %s" "$sep" "%{A:\"volume-adjust.sh\" mute:}" "$normal_color" "$(amixer -D pulse sget Master | grep 'Front Left:' | \
		awk -v c="$active_color" '{print($6,"%{F"c"}",$5)}' | sed 's/\[//g;s/\]//g;s/off /\\uf026/;s/on /\\uf028/')" "%{A}"
}

$hc pad $monitor $pan_h

battery=""
date=""
network=""
updates="$(updates_widget)"
volume="$(volume_widget)"
windowtitle=""

{
	### Event generator ###
	# based on different input data (mpc, date, hlwm hooks, ...) this generates events, formed like this:
	#   <eventname>\t<data> [...]

	while true; do
		# "date" and network output is checked once a second, but an event is
		# only generated if the output changed compared to the previous run.
		printf "%b\n%b\n" "$(network_widget)" "$(date_widget)"
		sleep 5 || break
	done > >(uniq_linebuffered) &
	childpid=$!
	"$hc" --idle
	kill $childpid
} 2>/dev/null | {
	IFS=$'\t' read -ra tags <<< "$($hc tag_status $monitor)"

	### Output ###
	while true; do
		battery="$(battery_widget)" # update battery on event trigger

		# draw tags
		for i in "${tags[@]}"; do
			case ${i:0:1} in
				'#') # current
					print_color_dual "$select_color" '-' ;;
				'+') # current (other monitor selected)
					print_color_dual "$normal_color" '-' ;;
				':') # active (not empty)
					print_color_dual '-' "$active_color" ;;
				'!') # alert
					print_color_dual "$urgent_color" '-' ;;
				'.') # inactive (empty)
					print_color_dual '-' "$normal_color" ;;
				'-' | '%') # current on other monitor
					print_color_dual '-' "$select_color" ;;
				*) # everything else
					print_color_dual '-' "$normal_color" ;;
			esac
			printf " %s " "${i:1}"
			#printf "%s %s %s" "%{A:\"$hc\" focus_monitor \"$monitor\" && \"$hc\" use \"${i:1}\":}" "${i:1}" "%{A}"
		done

		# draw everything after the tags
		printf "%s %s %s\n" "%{B-}$sep" "%{F$active_color}${windowtitle//^/^^}" \
			"%{r}$updates$network$volume$battery$date"

		### Data handling ###
		# This part handles the events generated in the event loop, and sets
		# internal variables based on them. The event and its arguments are read
		# into the array cmd, then action is taken depending on the event name.
		# "Special events" (quit_panel/togglehidepanel/reload) are handled here.

		IFS=$'\t' read -ra cmd || break # wait for next command
		case "${cmd[0]}" in # find out event origin
			tag*) IFS=$'\t' read -ra tags <<< "$($hc tag_status $monitor)" ;;
			date) date="${cmd[@]:1}" ;;
			network) network="${cmd[@]:1}" ;;
			updates) updates=$(updates_widget) ;;
			volume) volume=$(volume_widget) ;;
			quit_panel | reload) exit ;;
			focus_changed | window_title_changed) windowtitle="${cmd[@]:2}" ;;
		esac
	done

} 2>/dev/null | lemonbar -g ${pan_w}x${pan_h}+${off_x}+${off_y} -B "$backgd_color" -F "$backgd_color" -f $textfont -f $iconfont \
	| while read line; do eval "$line"; done
