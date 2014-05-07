#!/usr/bin/env bash

while read line; do
    if [[ -d ./files/$line ]]; then
        d=${line%/}
        echo "Copying directory: $d"
        mkdir -p $HOME/dotfiles/$d
        cp -r "./files/$d/." "$HOME/dotfiles/$d"
    else
        echo "Copying file: $line"
        mkdir -p "$HOME/dotfiles/$(dirname $line)"
        cp -r "./files/$line" "$HOME/dotfiles/$line"
    fi
done < include.dat
