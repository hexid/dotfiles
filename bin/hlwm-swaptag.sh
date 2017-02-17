#!/usr/bin/env bash

otherTag="$1"
otherDump="$(herbstclient dump "$otherTag")"
currTag="$(herbstclient attr tags.focus.name)"

herbstclient lock
herbstclient load "$otherTag" "$(herbstclient dump "$currTag")"
herbstclient load "$currTag" "$otherDump"
herbstclient use "$otherTag"
herbstclient unlock

