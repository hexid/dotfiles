#!/usr/bin/env sh

DIR="$(cd "$(dirname "$0")" && pwd)"

while read line; do
	if [[ ${line:0:1} == '#' ]]; then
		echo "Ignoring ${line:1}"
	elif [[ -d $HOME/$line ]]; then
		d=${line%/}
		echo "Copying directory: $d"
		mkdir -p $DIR/files/$d
		cp -r "$HOME/$d/." "$DIR/files/$d"
	else
		echo "Copying file: $line"
		mkdir -p "$DIR/files/$(dirname $line)"
		cp -r "$HOME/$line" "$DIR/files/$line"
	fi
done < include.dat
