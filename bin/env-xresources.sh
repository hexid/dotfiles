#!/usr/bin/env sh

while read -r name value; do
	export "_xrdb_$name"="$value"
done <<EOF
$(cpp "$XDG_CONFIG_HOME"/X11/Xresources | sed '/\s*!/d' | \
	awk 'match($0, /\.(color[0-9]+|foreground|background|iconfont|font)\s*:\s*(.*?)\s*/, a) { printf("%s %s\n", a[1], a[2]) }')
EOF
