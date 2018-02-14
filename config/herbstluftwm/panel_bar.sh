#!/usr/bin/env sh

monitor="$1"

hc="${herbstclient_command[@]:-herbstclient}"

active_color="$($hc attr theme.color)" # active text
backgd_color="$($hc attr theme.background_color)" # default fg/bg
normal_color="$($hc attr theme.normal.color)" # normal text
select_color="$($hc attr theme.active.color)" # selected tag bg
urgent_color="$($hc attr theme.urgent.color)" # urgent tag bg

sep="%{F${select_color}}|"

print_color_dual() { # background foreground
	printf "%%{B%s F%s}" "$1" "$2"
}

keyboard_widget() {
	printf "%s%s %%{F%s}%b %%{F%s}%s %s" "$sep" "%{A:keyboard:}" "$normal_color" "\uf11c" "$active_color" "$1" "%{A}"
}
network_widget() {
	addr="$(ip addr | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2 /p' | tr -d '\n')"
	if command -v iwgetid >/dev/null 2>&1; then
		ssid="$(iwgetid -r)"
	fi
	printf "%s %%{F%s}%b %%{F%s}%s" "$sep" "$normal_color" '\uf1eb' "$active_color" \
		"$([[ -z "$addr" ]] && printf 'None ' || printf "$addr")"
}
updates_widget() {
	file="${XDG_RUNTIME_DIR:-/tmp}/checkup-status"
	if [ -r $file ]; then
		upd="$(cat $file)"
		if [[ "$upd" != "0" ]]; then
			printf "%s %%{F%s}%b %%{F%s}%s " "$sep" "$normal_color" '\uf062' "$active_color" "$upd"
		fi
	fi
}
reboot_widget() {
	if [ -e /tmp/need-reboot ]; then
		printf "%s %%{F%s}%s " "$sep" "$active_color" "Reboot"
	fi
}
volume_widget() {
	printf "%s%b %%{F%s}%b %s" "$sep" "%{A:volume\tmute: A3:volume\trotate: A4:volume\tup: A5:volume\tdown:}" "$normal_color" \
		"$(amixer -D pulse sget Master | grep 'Front Left:' | awk -v c="$active_color" '{print($6,"%{F"c"}",$5)}' | \
			sed 's/\[//g;s/\]//g;s/off /\\uf026/;s/on /\\uf028/')" "%{A A A A}"
}

draw_tags() {
	# draw tags
	for i in "$@"; do
		case ${i:0:1} in
			'#') print_color_dual "$select_color" '-' ;; # selected + focused
			'+') print_color_dual "$normal_color" '-' ;; # selected + not focused
			':') print_color_dual '-' "$active_color" ;; # non-empty tag
			'!') print_color_dual "$urgent_color" '-' ;; # urgent window
			'.') print_color_dual '-' "$normal_color" ;; # empty tag
			'-' | '%') print_color_dual '-' "$select_color" ;; # other monitor
			*) print_color_dual '-' "$normal_color" ;;
		esac
		printf "%b %s %s" "%{A:tag_focus\t"${i:1}": A2:tag_swap\t"${i:1}": A3:tag_move\t"${i:1}":}" "${i:1}" '%{A A A}'
	done
}

while true; do
	IFS=$'\t' read -ra cmd || break # wait for next command
	case "${cmd[0]}" in # find out event origin
		tag*)
			IFS=$'\t' read -ra tags <<<"$("$hc" tag_status "$monitor")"
			tags_out="$(draw_tags "${tags[@]}")"
			;;
		battery)
			pwr="${cmd[@]:1}"
			battery="$(printf '%s %%{F%s}%b %%{F%s}%s ' "$sep" "$normal_color" "\uf24$((4 - ($pwr - 1) / 20))" "$active_color" "$pwr%")"
			;;
		date) date="$(date +"$sep %{F$normal_color}%a %{F$active_color}%-d %{F$normal_color}%b %Y %{F$active_color}%H:%M ")" ;;
		keyboard) keyboard=$(keyboard_widget "${cmd[@]:1}") ;;
		network) network="$(network_widget)" ;;
		reboot) reboot=$(reboot_widget) ;;
		status) status="${cmd[@]:1}" ;;
		updates) updates=$(updates_widget) ;;
		volume) volume=$(volume_widget) ;;
		quit_panel | reload) exit ;;
		focus_changed | window_title_changed) status="${cmd[@]:2}" ;;
		fullscreen) ;;
		urgent) ;;
		*) status="err: ${cmd[@]}" ;;
	esac

	printf '%s%s %s %s\n' "${tags_out}" "%{B-}$sep" "%{F$active_color}${status/^/^^}" \
		"%{r}$reboot$updates$keyboard$network$volume$battery$date"
done
