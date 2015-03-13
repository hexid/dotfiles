#!/usr/bin/env bash

export GIT_SSH="$XDG_CONFIG_HOME/git/git_ssh.sh"
export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
export HISTFILE="$XDG_DATA_HOME/history"
export INPUTRC="$XDG_CONFIG_HOME/inputrc"
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/password-store"
export RXVT_SOCKET="$XDG_RUNTIME_DIR/urxvtd.sock"
export VIMINIT='if empty($XDG_CONFIG_HOME) | let $XDG_CONFIG_HOME="$HOME/.config" | endif | let $MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc" | source $MYVIMRC'
export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"

systemctl --user import-environment GNUPGHOME XAUTHORITY

alias scp="scp -F $XDG_CONFIG_HOME/ssh/config"
alias ssh="ssh -F $XDG_CONFIG_HOME/ssh/config"
alias startx="startx $XDG_CONFIG_HOME/X11/xinitrc"
alias tmux="tmux -f $XDG_CONFIG_HOME/tmux/tmux.conf"