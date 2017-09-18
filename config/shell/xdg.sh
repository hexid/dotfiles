#!/usr/bin/env sh

export XDG_BIN_HOME="$HOME/.local/bin"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"

export ANDROID_SDK_HOME="$XDG_CONFIG_HOME/android"
export ATOM_HOME="$XDG_CONFIG_HOME/atom-editor"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export CCACHE_DIR="$XDG_CACHE_HOME/ccache"
export DVDCSS_CACHE="$XDG_DATA_HOME/dvdcss"
export GIMP2_DIRECTORY="$XDG_CONFIG_HOME/gimp-2.0"
export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
export HGRCPATH="$XDG_CONFIG_HOME/hg/hgrc"
export HISTFILE="$XDG_DATA_HOME/history"
export ICEAUTHORITY="$XDG_RUNTIME_DIR/ICEauthority"
export INPUTRC="$XDG_CONFIG_HOME/inputrc"
export LESSHISTFILE="$XDG_DATA_HOME/lesshst"
export MAVEN_OPTS="-Dmaven.repo.local=$XDG_DATA_HOME/maven/repository"
export MPD_HOST="$XDG_CONFIG_HOME/mpd/socket"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/config"
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/password-store/"
export TERMINFO="$XDG_DATA_HOME/terminfo"
export TERMINFO_DIRS="$XDG_DATA_HOME/terminfo:/usr/share/terminfo"
export TMUX_TMPDIR="$XDG_RUNTIME_DIR"
export WEECHAT_HOME="$XDG_CONFIG_HOME/weechat"
export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"

export PATH="$PATH:$XDG_BIN_HOME"

systemctl --user import-environment GNUPGHOME XAUTHORITY

if command -v startx >/dev/null 2>&1; then
	alias startx="startx $XDG_CONFIG_HOME/X11/xinitrc -- $XDG_CONFIG_HOME/X11/xserverrc"
fi
if command -v tmux >/dev/null 2>&1; then
	alias tmux="tmux -f $XDG_CONFIG_HOME/tmux/tmux.conf"
fi

alias ncmpcpp="ncmpcpp -c $XDG_CONFIG_HOME/ncmpcpp/config"
