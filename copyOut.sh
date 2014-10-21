#!/usr/bin/env sh

while read line; do
	if [[ ${line:0:1} == '#' ]]; then
		echo "Ignoring ${line:1}"
	elif [[ -d ./files/$line ]]; then
		d=${line%/}
		echo "Copying directory: $d"
		mkdir -p $HOME/$d
		cp -r "./files/$d/." "$HOME/$d"
	else
		echo "Copying file: $line"
		mkdir -p "$HOME/$(dirname $line)"
		cp -r "./files/$line" "$HOME/$line"
	fi
done < include.dat
