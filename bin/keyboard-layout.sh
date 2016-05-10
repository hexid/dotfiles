#!/usr/bin/env bash

layout=$(setxkbmap -query | awk 'END{print $2}')

if [[ "$1" = "-q" ]]; then
	printf "keyboard\t%s\n" "$layout"
else
	IFS=' ' read -r -a cycle <<< "${XKB_LAYOUTS:-us}"
	if [[ -n "$1" ]]; then
		new_layout="$1"
		setxkbmap "$new_layout"
	else
		for index in ${!cycle[@]}; do
			if [[ "${cycle[$index]}" = "$layout" ]]; then
				new_layout="${cycle[$(($index + 1))]}"
				break
			fi
		done
	fi

	if [[ -z "$new_layout" ]]; then
		new_layout="${cycle[0]}"
	fi
	setxkbmap "$new_layout"
	herbstclient emit_hook keyboard "$new_layout"
fi
