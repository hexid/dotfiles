#!/usr/bin/env sh

FORCE=0
while getopts :f FLAG; do
	case $FLAG in
		f) FORCE=1 ;;
	esac
done

# check if /boot is on a separate partition and that it is not mounted
if findmnt --fstab -uno SOURCE /boot >/dev/null 2>&1 && ! mountpoint -q /boot; then
	printf "Mounting /boot/\n"
	sudo mount /boot # attempt to mount it
	if ! mountpoint -q /boot; then # exit if it is still not mounted
		printf "Boot volume not mounted. Exiting\n"; exit
	fi
fi

kernels="$(pacman -Qo /boot/vmlinuz* 2>/dev/null | cut -d' ' -f5)"
for pkg in $kernels; do
	curr="$(pacman -Q $pkg | cut -d' ' -f2)"
	vmlinuz="$(pacman -Ql $pkg | grep '/boot/..*' | cut -d' ' -f2)"
	boot="$(file $vmlinuz | grep -oP 'version (\d+\.?)+-\d' | cut -d' ' -f2)"
	printf "%s: %s  %s\n" "$pkg" "$curr" "$boot"
	if [ "$curr" != "$boot" ] || [ $FORCE -eq 1 ]; then
		printf "Reinstalling %s\n" "$pkg"
		sudo pacman -S $pkg
	fi
done

sync
