#
# ~/.bash_profile
#

export PATH="$PATH:$HOME/.local/bin"

[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx "${XDG_CONFIG_HOME:-$HOME/.config}/xinitrc"

[[ -f $HOME/.bashrc ]] && . $HOME/.bashrc
