#!/usr/bin/env sh

case "$1" in
	down)
		amixer -q -D pulse sset Master 5%-
		;;
	up)
		amixer -q -D pulse sset Master 5%+
		;;
	mute)
		amixer -q -D pulse set Master Playback Switch toggle
		;;
	rotate)
		currentSink="$(pactl info | grep 'Default Sink: ' | awk '{print $NF}')"
		sinksArray=($(pactl list short sinks | cut -f2))

		while [[ "$currentSink" != "${sinksArray[0]}" ]]; do
			sinksArray=("${sinksArray[@]: -1}" "${sinksArray[@]:0:${#sinksArray[@]}-1}")
		done
		sinksArray=("${sinksArray[@]: -1}" "${sinksArray[@]:0:${#sinksArray[@]}-1}")

		pactl set-default-sink "${sinksArray[0]}"
		pactl list short sink-inputs | while read line; do
			pactl move-sink-input "$(echo "$line" | cut -f1)" "@DEFAULT_SINK@" 2>/dev/null
		done

		sink="$(pactl list sinks | grep -A 1 -F "Name: ${sinksArray[0]}" | grep 'Description: ' | cut -d' ' -f2-)"
		herbstclient emit_hook status "PulseAudio Sink: ${sink}"
		;;
esac
herbstclient emit_hook volume
