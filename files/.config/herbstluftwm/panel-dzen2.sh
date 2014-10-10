#!/usr/bin/env bash

hc() { "${herbstclient_command[@]:-herbstclient}" "$@" ;}
monitor=${1:-0}
geometry=( $(herbstclient monitor_rect "$monitor") )
if [ -z "$geometry" ] ;then
    echo "Invalid monitor $monitor"
    exit 1
fi
# geometry has the format W H X Y
x=${geometry[0]}
y=${geometry[1]}
panel_width=${geometry[2]}
panel_height=15
font="-*-fixed-medium-*-*-*-12-*-*-*-*-*-*-*"
bgcolor=$(hc get frame_border_normal_color)
selbg=$(hc get window_border_active_color)
selfg='#101010'

active_color='#ffffff'
normal_color='#ababab'

textwidth="textwidth";

uniq_linebuffered() {
	awk '$0 != l { print ; l=$0 ; fflush(); }' "$@"
}

battery_widget() {
	echo "^fg($normal_color)Power: ^fg($active_color)$(expr $(expr $(cat /sys/class/power_supply/BAT0/charge_now) \* 100) / $(cat /sys/class/power_supply/BAT0/charge_full))%"
}
date_widget() {
	date +"date\t^fg($active_color)%-d ^fg($normal_color)%b %Y ^fg($active_color)%H:%M"
}
network_widget() {
	addr=$(ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')
	adapter=$(cat /sys/class/net/bond0/bonding/active_slave)
	echo -e "network\t^fg($normal_color)IP: ^fg($active_color)$([[ -z ${addr} ]] && echo 'None' || echo ${addr} ${adapter})"
}
volume_widget() {
	echo "^fg($normal_color)Vol: ^fg($active_color)$(amixer -D pulse sget Master | grep 'Front Left:' | cut -d ' ' -f7,8 | sed 's/\[//g;s/\]//g;s/off/Mute/;s/ on//')"
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

	while true ; do
		# "date" output is checked once a second, but an event is only
		# generated if the output changed compared to the previous run.
		echo -e "$(date_widget)\n$(network_widget)"
		sleep 5 || break
	done > >(uniq_linebuffered) &
	childpid=$!

	hc --idle
	kill $childpid
} 2> /dev/null | {
	IFS=$'\t' read -ra tags <<< "$(hc tag_status $monitor)"
	visible=true

	while true ; do
		### Output ###
		# This part prints dzen data based on the _previous_ data
		# handling run, and then waits for the next event to happen.

		battery=$(battery_widget) # only update the battery when another event is triggered

		bordercolor="#26221C"
		separator="^bg()^fg($selbg)|"
		# draw tags
		for i in "${tags[@]}" ; do
			case ${i:0:1} in
				'#') # current
					echo -n "^bg($selbg)^fg($selfg)"
					;;
				'+')
					echo -n "^bg(#9CA668)^fg(#141414)"
					;;
				':') # active
					echo -n "^bg()^fg($active_color)"
					;;
				'!')
					echo -n "^bg(#FF0675)^fg(#141414)"
					;;
				*) # inactive
					echo -n "^bg()^fg($normal_color)"
					;;
			esac
			echo -n " ${i:1} "
		done
		echo -n "$separator"
		echo -n "^bg()^fg() ${windowtitle//^/^^}"
		# small adjustments
		right="$separator $network $separator $volume $separator $battery $separator $date $separator"
		right_text_only=$(echo -n "$right" | sed 's.\^[^(]*([^)]*)..g')
		# get width of right aligned text.. and add some space..
		width=$($textwidth "$font" "$right_text_only ")
		echo -n "^pa($(($panel_width - $width)))$right"
		echo

		### Data handling ###
		# This part handles the events generated in the event loop, and sets
		# internal variables based on them. The event and its arguments are
		# read into the array cmd, then action is taken depending on the event
		# name.
		# "Special" events (quit_panel/togglehidepanel/reload) are also handled
		# here.

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
			quit_panel)
				exit
				;;
			togglehidepanel)
				currentmonidx=$(hc list_monitors | sed -n '/\[FOCUS\]$/s/:.*//p')
				if [ "${cmd[1]}" -ne "$monitor" ] ; then
					continue
				fi
				if [ "${cmd[1]}" = "current" ] && [ "$currentmonidx" -ne "$monitor" ] ; then
					continue
				fi
				echo "^togglehide()"
				if $visible ; then
					visible=false
					hc pad $monitor 0
				else
					visible=true
					hc pad $monitor $panel_height
				fi
				;;
			reload)
				exit
				;;
			focus_changed|window_title_changed)
				windowtitle="${cmd[@]:2}"
				;;
		esac
	done

	### dzen2 ###
	# After the data is gathered and processed, the output of the previous block
	# gets piped to dzen2.

} 2> /dev/null | dzen2 -w $panel_width -h $panel_height -x $x -y $y -fn "$font" -ta l -bg "$bgcolor" -fg '#efefef'
