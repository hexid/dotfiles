#!/bin/bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 0.1; done

bar_name="top"

bar_offset="$(polybar "$bar_name" -d height)"
for m in $(herbstclient list_monitors | cut -d':' -f1); do
	herbstclient pad "$m" "$bar_offset"
done

for m in $(polybar --list-monitors | cut -d':' -f1); do
	MONITOR="$m" polybar --reload "$bar_name" &
done

echo "Bars launched..."
