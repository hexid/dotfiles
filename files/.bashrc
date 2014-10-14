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
	export PS1="$fill\r[\[\033[1;34m\]\u@\h\033[0;m\]::\[\033[1;31m\]\$ret\[\033[0;m\]]\033[1C[\[\033[1;32m\]\${PWD##*/}\[\033[0;m\]\$(__git_ps1 \"::\[\033[1;34m\]%s\[\033[0;m\]\")]\nλ "
}
PROMPT_COMMAND="prompt_gen"

PATH="`ruby -e 'puts Gem.user_dir'`/bin:$PATH"

export EDITOR="vim"

export GOPATH="$HOME/workspace/go"

if [ "$TERM" = "linux" ]; then
	_SEDCMD='s/.*\*color\([0-9]\{1,\}\).*#\([0-9a-fA-F]\{6\}\).*/\1 \2/p'
	for i in $(sed -n "$_SEDCMD" $HOME/.Xresources | \
				awk '$1 < 16 {printf "\\e]P%X%s", $1, $2}'); do
		echo -en "$i"
	done
	clear
fi
