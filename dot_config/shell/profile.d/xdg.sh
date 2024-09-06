#!/usr/bin/env sh

export XDG_BIN_HOME="$HOME/.local/bin"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

export _JAVA_OPTIONS="-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java"
export ANDROID_SDK_HOME="$XDG_CONFIG_HOME/android"
export ATOM_HOME="$XDG_CONFIG_HOME/atom-editor"
#export AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME/aws/credentials"
#export AWS_CONFIG_FILE="$XDG_CONFIG_HOME/aws/config"
export BUNDLE_USER_CONFIG="$XDG_CONFIG_HOME/bundle"
export BUNDLE_USER_CACHE="$XDG_CACHE_HOME/bundle"
export BUNDLE_USER_PLUGIN="$XDG_DATA_HOME/bundle"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export CCACHE_DIR="$XDG_CACHE_HOME/ccache"
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export DVDCSS_CACHE="$XDG_DATA_HOME/dvdcss"
export GEM_HOME="$XDG_DATA_HOME/gem"
export GEM_SPEC_CACHE="$XDG_CACHE_HOME/gem"
export GIMP2_DIRECTORY="$XDG_CONFIG_HOME/gimp-2.0"
export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
export HGRCPATH="$XDG_CONFIG_HOME/hg/hgrc"
export HISTFILE="$XDG_DATA_HOME/${SHELL##*/}_history" # XDG_STATE_HOME
export ICEAUTHORITY="$XDG_CACHE_HOME/ICEauthority"
export INPUTRC="$XDG_CONFIG_HOME/inputrc"
export LESSHISTFILE="$XDG_DATA_HOME/lesshst"
export MAVEN_OPTS="-Dmaven.repo.local=$XDG_CACHE_HOME/maven/repository"
export MPD_HOST="$XDG_CONFIG_HOME/mpd/socket"
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/password-store/"
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
export SSLKEYLOGFILE="$XDG_RUNTIME_DIR/sslkeylog"
#export TERMINFO="$XDG_DATA_HOME/terminfo"
export TERMINFO_DIRS="$XDG_DATA_HOME/terminfo:/usr/share/terminfo"
export TMUX_TMPDIR="$XDG_RUNTIME_DIR"
export WEECHAT_HOME="$XDG_CONFIG_HOME/weechat"
export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"

export PATH="$PATH:$XDG_BIN_HOME"

unset GRADLE_HOME # fixes an issue with the java plugin for vscode

systemctl --user import-environment GNUPGHOME XAUTHORITY

if command -v startx >/dev/null 2>&1; then
	alias startx="startx $XDG_CONFIG_HOME/X11/xinitrc -- $XDG_CONFIG_HOME/X11/xserverrc"
fi
if command -v tmux >/dev/null 2>&1; then
	alias tmux="tmux -f $XDG_CONFIG_HOME/tmux/tmux.conf"
fi

alias ncmpcpp="ncmpcpp -c $XDG_CONFIG_HOME/ncmpcpp/config"
