#!/usr/bin/env sh

FORCE=0
while getopts :f FLAG; do
	case $FLAG in
		f)
			FORCE=1
			;;
	esac
done

if grep -qs '/boot' /etc/fstab; then
	sudo mount /boot
	if ! grep -qs '/boot' /proc/mounts; then
		echo "Boot volume not mounted. Exiting"
		exit
	fi
fi

for k in linux linux-lts; do
	curr="$(pacman -Q $k | cut -d' ' -f2)"
	boot="$(file /boot/vmlinuz-$k | grep -oP 'version (\d+\.?)+-\d' | cut -d' ' -f2)"
	echo "$curr  $boot"
	if [ "$curr" != "$boot" ] || [ $FORCE -eq 1 ]; then
		echo "Rebuilding $k"
		sudo mkinitcpio -p "$k"
	fi
done
