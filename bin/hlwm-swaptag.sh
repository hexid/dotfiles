#!/usr/bin/env bash

currTag="$(herbstclient attr tags.focus.name)"
currDump="$(herbstclient dump)"
herbstclient chain .. lock .. "${@}"
otherDump="$(herbstclient dump)"
herbstclient chain .. load "${currDump}" .. \
	load "${currTag}" "${otherDump}" .. unlock
