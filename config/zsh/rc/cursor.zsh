zle-line-init() {
	zle -K viins
	printf "\033[4 q"
}
zle -N zle-line-init
zle-keymap-select() {
	if [[ $KEYMAP == vicmd ]]; then
		if [[ -z $TMUX ]]; then
			printf "\033[2 q"
		else
			printf "\033Ptmux;\033\033[2 q\033\\"
		fi
	else
		if [[ -z $TMUX ]]; then
			printf "\033[4 q"
		else
			printf "\033Ptmux;\033\033[4 q\033\\"
		fi
	fi
}
zle -N zle-keymap-select
