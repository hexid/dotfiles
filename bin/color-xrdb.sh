#!/usr/bin/env sh

while read -r name hex; do
	export "_xrdb_$name"=$hex
done <<EOF
$(xrdb -query | gawk 'match($0, /(color[0-9]+|foreground|background)\s*:\s*(#[0-9a-zA-Z]{3,6})/, a) { printf("%s %s\n", a[1], a[2]) }')
EOF
