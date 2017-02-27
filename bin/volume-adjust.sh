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
		sinksArray="$(pactl list short sinks | cut -f2)"

		while [ "${sinksArray##*$'\n'}" != "${currentSink}" ]; do
			sinksArray="$(printf '%s\n' "${sinksArray}" | sed -e '1h;1d;$G')"
		done
		nextSink="${sinksArray%%$'\n'*}"

		pactl set-default-sink "${nextSink}"
		pactl list short sink-inputs | while read line; do
			pactl move-sink-input "$(echo "$line" | cut -f1)" "@DEFAULT_SINK@" 2>/dev/null
		done

		sink="$(pactl list sinks | grep -A 1 -F "Name: ${nextSink}" | grep 'Description: ' | cut -d' ' -f2-)"
		herbstclient emit_hook status "PulseAudio Sink: ${sink}"
		;;
esac
herbstclient emit_hook volume
