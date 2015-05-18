#!/usr/bin/env bash

while read line; do
	name="_xrdb_$(echo "$line" | cut -d' ' -f1)"
	hex=$(echo "$line" | cut -d' ' -f2)
	export $name=$hex
done < <(xrdb -query | gawk 'match($0, /(color[0-9]+|foreground|background)\s*:\s*(#[0-9a-zA-Z]{3,6})/, a) { printf ("%s %s\n", a[1], a[2]) }')
