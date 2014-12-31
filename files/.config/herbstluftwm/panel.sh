#!/usr/bin/env bash

hc() { "${herbstclient_command[@]:-herbstclient}" "$@" ;}
monitor=${1:-0}
geometry=( $(herbstclient monitor_rect "$monitor") )
if [ -z "$geometry" ]; then
	echo "Invalid monitor $monitor"
	exit 1
fi
# geometry has the format W H X Y
x=${geometry[0]}
y=${geometry[1]}
panel_width=${geometry[2]}
panel_height=15
font="-*-fixed-medium-*-*-*-12-*-*-*-*-*-*-*"
alpha="#FF"
alpha_attr() {
	attr="$(hc attr $1)"
	echo "${attr/\#/$alpha}"
}

active_color="$(alpha_attr theme.outer_color)"
backgd_color="$(alpha_attr theme.background_color)"
normal_color="$(alpha_attr theme.normal.color)"
select_color="$(alpha_attr theme.active.color)"
urgent_color="$(alpha_attr theme.urgent.color)"

sep="%{B-}%{F$select_color}| "

uniq_linebuffered() {
	awk '$0 != l { print ; l=$0 ; fflush(); }' "$@"
}

battery_widget() {
	if [ -x /sys/class/power_supply/BAT0 ]; then
		echo " $sep%{F$normal_color}Power: %{F$active_color}$(expr $(expr $(cat /sys/class/power_supply/BAT0/charge_now) \* 100) / $(cat /sys/class/power_supply/BAT0/charge_full))%%"
	fi
}
date_widget() {
	date +"date\t $sep%{F$active_color}%-d %{F$normal_color}%b %Y %{F$active_color}%H:%M"
}
network_widget() {
	addr=$(ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')
	adapter=$(cat /sys/class/net/bond0/bonding/active_slave)
	echo -e "network\t $sep%{F$normal_color}IP: %{F$active_color}$([[ -z ${addr} ]] && echo 'None' || echo ${addr} ${adapter})"
}
volume_widget() {
	echo " $sep%{F$normal_color}Vol: %{F$active_color}$(amixer -D pulse sget Master | grep 'Front Left:' | cut -d ' ' -f7,8 | sed 's/\[//g;s/\]//g;s/off/Mute/;s/ on//;s/%/%%/')"
}

hc pad $monitor $panel_height

battery=""
date=""
network=""
volume=$(volume_widget)
windowtitle=""

{
	### Event generator ###
	# based on different input data (mpc, date, hlwm hooks, ...) this generates events, formed like this:
	#   <eventname>\t<data> [...]

	while true; do
		# "date" and network output is checked once a second, but an event is
		# only generated if the output changed compared to the previous run.
		echo -e "$(date_widget)\n$(network_widget)"
		sleep 5 || break
	done >>>(uniq_linebuffered) &
	childpid=$!
	hc --idle
	kill $childpid
} 2> /dev/null | {
	IFS=$'\t' read -ra tags <<< "$(hc tag_status $monitor)"

	while true; do
		### Output ###
		battery=$(battery_widget) # update battery on event trigger

		# draw tags
		for i in "${tags[@]}" ; do
			case ${i:0:1} in
				'#') # current
					echo -n "%{B$select_color}%{F-}"
					;;
				'+') # other monitor
					echo -n "%{B$normal_color}%{F-}"
					;;
				':') # active (not empty)
					echo -n "%{B-}%{F$active_color}"
					;;
				'!') # alert
					echo -n "%{B${urgent_color}}%{F-}"
					;;
				*) # inactive (empty)
					echo -n "%{B-}%{F$normal_color}"
					;;
			esac
			echo -n " ${i:1} "
			#echo -en "%{A:\"${herbstclient_command[@]:-herbstclient}\" focus_monitor \"$monitor\" && \"${herbstclient_command[@]:-herbstclient}\" use \"${i:1}\":} ${i:1} %{A}"
		done
		echo -n "$sep%{F${active_color}}${windowtitle//^/^^}"
		echo -n "%{r}$network$volume$battery$date "
		echo

		### Data handling ###
		# This part handles the events generated in the event loop, and sets
		# internal variables based on them. The event and its arguments are read
		# into the array cmd, then action is taken depending on the event name.
		# "Special events" (quit_panel/togglehidepanel/reload) are handled here.

		# wait for next event
		IFS=$'\t' read -ra cmd || break
		# find out event origin
		case "${cmd[0]}" in
			tag*)
				IFS=$'\t' read -ra tags <<< "$(hc tag_status $monitor)"
				;;
			date)
				date="${cmd[@]:1}"
				;;
			network)
				network="${cmd[@]:1}"
				;;
			volume)
				volume=$(volume_widget)
				;;
			quit_panel | reload)
				exit
				;;
			focus_changed | window_title_changed)
				windowtitle="${cmd[@]:2}"
				;;
		esac
	done

} 2>/dev/null | bar-aint-recursive -g ${panel_width}x${panel_height}+${x}+${y} -B "$backgd_color" -F "$backgd_color" -f $font #| while read line; do eval "$line"; done
