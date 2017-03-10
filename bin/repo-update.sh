#!/usr/bin/env bash

REPOPATH="/opt/configuration/webserver/srv/http/hexid.me/repo/archlinux/x86_64/"
REPO="hexid.db.tar.xz"
FILE="$1"
FILENAME="${FILE##*/}"

if [ "$(file -b "$FILE")" == "* tar archive" ]; then
	cat "$FILE" | xz | sudo tee "${REPOPATH}${FILENAME}.xz" >/dev/null
	FILENAME="${FILENAME}.xz"
else
	sudo cp "$FILE" "$REPOPATH"
fi

sudo repo-add -R "${REPOPATH}${REPO}" "${REPOPATH}${FILENAME}"
