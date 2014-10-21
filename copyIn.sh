#!/usr/bin/env sh

while read line; do
	if [[ ${line:0:1} == '#' ]]; then
		echo "Ignoring ${line:1}"
	elif [[ -d $HOME/$line ]]; then
		d=${line%/}
		echo "Copying directory: $d"
		mkdir -p ./files/$d
		cp -r "$HOME/$d/." "./files/$d"
	else
		echo "Copying file: $line"
		mkdir -p "./files/$(dirname $line)"
		cp -r "$HOME/$line" "./files/$line"
	fi
done < include.dat
