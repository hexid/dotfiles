zle-line-init() {
	zle -K viins
	if [ "$TERM" = "linux" ]; then
		printf "\033[?0;0;255c"
	else
		printf "\033[4 q"
	fi
}
zle -N zle-line-init
zle-keymap-select() {
	if [ "$KEYMAP" = "vicmd" ]; then
		if [ "$TERM" = "linux" ]; then
			printf "\033[?16;0;255c"
		else
			printf "\033[2 q"
		fi
	else
		if [ "$TERM" = "linux" ]; then
			printf "\033[?0;0;255c"
		else
			printf "\033[4 q"
		fi
	fi
}
zle -N zle-keymap-select
