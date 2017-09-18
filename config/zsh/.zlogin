# if any of these conditions are not met, we will just drop into a terminal
# * current virtual terminal is tty1
# * DISPLAY env var is not set
# * TMUX env var is not set
# * startx command exists
if [[ -z $DISPLAY && $XDG_VTNR -eq 1 && -z $TMUX ]] && command -v startx >/dev/null 2>&1; then
	exec startx $XDG_CONFIG_HOME/X11/xinitrc -- $XDG_CONFIG_HOME/X11/xserverrc
fi
