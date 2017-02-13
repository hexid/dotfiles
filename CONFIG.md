configuration
=============

# GPG

### ~/.config/gnupg/gpg.conf

```
keyserver-options auto-key-retrieve
```

# Kernel

### /etc/mkinitcpio.conf

```
# i915: intel early-start KMS
# xhci-hcd: USB3 boot support
MODULES="i915 xhci-hcd"

# encrypt: support for encrypted filesystems
# lvm2: support for LVM
HOOKS="base udev autodetect modconf block encrypt lvm2 filesystems keyboard fsck"
```

# Keymap

```
$ localectl set-keymap --no-convert dvorak
$ localectl set-x11-keymap --no-convert us,us pc104 dvorak, grp:rctrl_rshift_toggle
```

# Pacman

### /etc/pacman.conf

```
Color
TotalDownload
CheckSpace
VerbosePkgLists
ILoveCandy

[hexid]
SigLevel = Optional TrustAll
Server = http://repo.hexid.me/archlinux/$arch
```

# Pulseaudio

### ~/.config/pulse/default.pa
#### Copy file from /etc/pulse/default.pa

```
# Switch to new sink/source when connected
load-module module-switch-on-connect

# New (and restored) streams will use the default sink
load-module module-stream-restore restore_device=false
```

# SSH

### ~/.ssh/config

```
IdentitiesOnly yes
UserKnownHostsFile ~/.ssh/known_hosts
VisualHostKey yes

Host name name-vpn
	HostName fqdn.com
	IdentityFile ~/.ssh/keys/_date_/name_ed25519
	User username

Host vpn
	HostName ip.addr
	IdentityFile ~/.ssh/keys/_date_/vpn_ed25519
	User username

Host *-vpn
	ProxyCommand ssh -W %h:%p vpn
```

# Weechat

```
$ weechat
> /secure passphrase <passphrase>
> /secure set freenode <passphrase>
```
