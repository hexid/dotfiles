#!/usr/bin/env bash

outputs() {
	OUTPUT=$(pactl list short sinks | cut  -f 2 | rofi -dmenu -p 'Output' -mesg 'Select prefered output source')
	pactl set-default-sink "$OUTPUT" >/dev/null 2>&1

	for playing in $(pactl list short sink-inputs | cut -f 1); do
		pactl move-sink-input "$playing" "$OUTPUT" >/dev/null 2>&1
	done
}

inputs() {
	INPUT=$(pactl list short sources | cut  -f 2 | grep input | rofi -dmenu -p 'Input' -mesg 'Select prefered input source')
	pactl set-default-source "$INPUT" >/dev/null 2>&1

	for recording in $(pactl list short source-outputs | cut -f 1); do
		pactl move-source-output "$recording" "$INPUT" >/dev/null 2>&1
	done
}

volume_up() {
	pactl set-sink-volume @DEFAULT_SINK@ +5%
}

volume_down() {
	pactl set-sink-volume @DEFAULT_SINK@ -5%
}

mute() {
	pactl set-sink-mute @DEFAULT_SINK@ toggle
}

volume_source_up() {
	pactl set-source-volume @DEFAULT_SOURCE@ +5%
}

volume_source_down() {
	pactl set-source-volume @DEFAULT_SOURCE@ -5%
}

mute_source() {
	pactl set-source-mute @DEFAULT_SOURCE@ toggle
}

get_default_sink() {
	pactl info | awk -F': ' '/^Default Sink: /{print $2}'
}

output_volume() {
	pactl list sinks | awk '/^\s+Name: /{indefault = $2 == "'"$(get_default_sink)"'"}
			/^\s+Mute: / && indefault {muted=$2}
			/^\s+Volume: / && indefault {volume=$5}
			END { print muted=="no"?"":"", volume }'
}

get_default_source() {
	pactl info | awk -F": " '/^Default Source: /{print $2}'
}

input_volume() {
	pactl list sources | awk '/^\s+Name: /{indefault = $2 == "'"$(get_default_source)"'"}
			/^\s+Mute: / && indefault {muted=$2}
			/^\s+Volume: / && indefault {volume=$5}
			END { print muted=="no"?"":"", volume }'
}

output_volume_listener() {
	pactl subscribe | while read -r event; do
		if echo "$event" | grep -q "'change' on sink"; then
			output_volume
		fi
	done
}

input_volume_listener() {
	pactl subscribe | while read -r event; do
		if echo "$event" | grep -q "'change' on source"; then
			input_volume
		fi
	done
}

case "$1" in
	--output) outputs ;;
	--input) inputs ;;
	--mute) mute ;;
	--mute-source) mute_source ;;
	--volume-up) volume_up ;;
	--volume-down) volume_down ;;
	--volume-source-up) volume_source_up ;;
	--volume-source-down) volume_source_down ;;
	--output-volume) output_volume ;;
	--input-volume) input_volume ;;
	--output-volume-listener)
		output_volume
		output_volume_listener
		;;
	--input-volume-listener)
		input_volume
		input_volume_listener
		;;
	*) echo "Wrong argument" ;;
esac

