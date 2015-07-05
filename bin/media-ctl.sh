#!/usr/bin/env sh

CTL="$(cd "$(dirname "$0")/media-ctl.d/" && pwd)"

# source scripts from ./media-ctl.d/
# each script should check to make sure
# that the process it commands is running

if test -d "$CTL"; then
	for media in $CTL/*.sh; do
		test -r "$media" && . "$media"
	done
fi
