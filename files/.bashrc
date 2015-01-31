#!/usr/bin/env bash

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

HISTCONTROL=ignoredups:erasedups
shopt -s histappend
shopt -s autocd

if [ -f /usr/share/git/completion/git-prompt.sh ]; then
	source /usr/share/git/completion/git-prompt.sh
	#GIT_PS1_SHOWDIRTYSTATE=1
	#GIT_PS1_SHOWSTASHSTATE=1
	#GIT_PS1_SHOWUNTRACKEDFILES=1
fi
if [ -f ~/.config/aliases ]; then
	. ~/.config/aliases
fi
if [ -f ~/.dircolors ]; then
	eval "$(dircolors ~/.dircolors)"
elif [ -f /etc/DIR_COLORS ]; then
	eval "$(dircolors /etc/DIR_COLORS)"
fi

function prompt_gen() {
	let ret=$? # must be first
	local fill=$(printf "%$(tput cols)s\n" | sed "s/ /─/g")
	export PS1="$fill\r[\[\e[1;32m\]\u\e[0;m\]@\e[1;33m\]\h\e[0;m\]::\[\e[1;31m\]\$ret\[\e[0;m\]]\e[1C[\[\e[1;34m\]\${PWD##*/}\[\e[0;m\]\$(__git_ps1 \"::\[\e[1;36m\]%s\[\e[0;m\]\")]\nλ "
}
PROMPT_COMMAND="prompt_gen"

export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"

export EDITOR='/usr/bin/vim'
export VISUAL='/usr/bin/vim'
export VIMINIT='if empty($XDG_CONFIG_HOME) | let $XDG_CONFIG_HOME="$HOME/.config" | endif | let $MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc" | source $MYVIMRC'

export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"

#PATH="`ruby -e 'puts Gem.user_dir'`/bin:$PATH"
#export GOPATH="$HOME/workspace/go"

systemctl --user import-environment GNUPGHOME

if [ "$TERM" = "linux" ]; then
	_SEDCMD='s/.*\*color\([0-9]\{1,\}\).*#\([0-9a-fA-F]\{6\}\).*/\1 \2/p'
	for i in $(sed -n "$_SEDCMD" $HOME/.Xresources | \
				awk '$1 < 16 {printf "\\e]P%X%s", $1, $2}'); do
		echo -en "$i"
	done
	clear
fi

