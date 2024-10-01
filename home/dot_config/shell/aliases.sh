#!/usr/bin/env sh

alias dmesg='journalctl -ko short-monotonic --no-hostname'
alias grep='grep --color=auto'
alias ls='ls -F --color=auto'
alias ll='ls -lAh'
alias rm='echo | xargs -p rm'
alias tree='tree -F'

alias lsblk='lsblk -o NAME,SIZE,TYPE,RM,RO,UUID,MOUNTPOINT'

alias sudodiff='SUDO_EDITOR="nvim -d" sudoedit'
alias pacdiff='DIFFPROG="nvim -d" pacdiff --sudo'
alias vim='nvim'
alias vimdiff='nvim -d'

alias pycalc='python3 -ic "from math import *"'
alias pyserv='python3 -m http.server 7777'

alias clip-copy='xsel --clipboard --input <'
alias clip-paste='xsel --clipboard --output >'

bashisms() {
	checkbashisms -f -p $(grep -IrlE '^#! ?(/usr)?/bin/(env )?sh' "$@")
}
cd() {
	builtin cd "$@" && ls
}
mirrorlist() {
	curl -s "https://archlinux.org/mirrorlist/?country=US&protocol=https&use_mirror_status=on" \
		| sed -e 's/^#Server/Server/' -e '/^#/d' \
		| rankmirrors -n 5 - \
		| sudo tee /etc/pacman.d/mirrorlist
}
wcf() {
	if [ -z "$1" ]; then
		find . | xargs wc -l
	else
		find . -name "*.${1}" | xargs wc -l
	fi
}

stopwatch() {
	dateStart=`date +%s`

	while true; do
		printf "\r$(date -u --date @$((`date +%s` - $dateStart)) +%H:%M:%S)";
		sleep 1
	done
}
