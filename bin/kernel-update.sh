#!/usr/bin/env sh

FORCE=0
while getopts :f FLAG; do
	case $FLAG in
		f) FORCE=1 ;;
	esac
done

# check if /boot is on a separate partition and that it is not mounted
if findmnt --fstab -uno SOURCE /boot >/dev/null 2>&1 && ! mountpoint -q /boot; then
	sudo mount /boot # attempt to mount it
	if ! mountpoint -q /boot; then # exit if it is still not mounted
		printf "Boot volume not mounted. Exiting\n"; exit
	fi
fi

for k in linux linux-lts linux-ck:sandybridge; do
	IFS=: read kernel pkg_ext <<EOF
$k
EOF

	if [ -z "$pkg_ext" ]; then
		pkg="$kernel"
	else
		pkg="$kernel-$pkg_ext"
	fi

	curr="$(pacman -Q $pkg | cut -d' ' -f2)"
	boot="$(file /boot/vmlinuz-$kernel | grep -oP 'version (\d+\.?)+-\d' | cut -d' ' -f2)"
	printf "%s: %s  %s\n" "$kernel" "$curr" "$boot"
	if [ "$curr" != "$boot" ] || [ $FORCE -eq 1 ]; then
		printf "Reinstalling %s\n" "$pkg"
		sudo pacman -S $pkg
	fi
done

sync
