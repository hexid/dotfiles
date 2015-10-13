#!/usr/bin/env bash

export XDG_BIN_HOME="$HOME/.local/bin"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"

export CARGO_HOME="$XDG_DATA_HOME/cargo"
export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
export HISTFILE="$XDG_DATA_HOME/history"
export INPUTRC="$XDG_CONFIG_HOME/inputrc"
export MPD_HOST="$XDG_CONFIG_HOME/mpd/socket"
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/password-store/"
export RXVT_SOCKET="$XDG_RUNTIME_DIR/urxvtd.sock"
export TMUX_TMPDIR="$XDG_RUNTIME_DIR"
export VIMINIT='if empty($XDG_CONFIG_HOME) | let $XDG_CONFIG_HOME="$HOME/.config" | endif | let $MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc" | source $MYVIMRC'
export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"

systemctl --user import-environment GNUPGHOME XAUTHORITY

if command -v startx >/dev/null 2>&1; then
	alias startx="startx $XDG_CONFIG_HOME/X11/xinitrc -- $XDG_CONFIG_HOME/X11/xserverrc"
fi
alias tmux="tmux -f $XDG_CONFIG_HOME/tmux/tmux.conf"
alias weechat="weechat -d $XDG_CONFIG_HOME/weechat/"
