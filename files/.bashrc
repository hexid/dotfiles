#!/usr/bin/env bash

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ -f /usr/share/git/completion/git-prompt.sh ]; then
    source /usr/share/git/completion/git-prompt.sh
    #GIT_PS1_SHOWDIRTYSTATE=1
    #GIT_PS1_SHOWSTASHSTATE=1
    #GIT_PS1_SHOWUNTRACKEDFILES=1
fi
if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi
if [ -f ~/.bash_functions ]; then
    source ~/.bash_functions
fi
if [ -f ~/.dircolors ]; then
    eval "$(dircolors ~/.dircolors)"
elif [ -f /etc/DIR_COLORS ]; then
    eval "$(dircolors /etc/DIR_COLORS)"
fi

function prompt_gen() {
    let ret=$? # must be first
    local fill=$(printf '%*s' "$(tput cols)" | tr ' ' '-')
    export PS1="$fill\r[\[\033[1;34m\]\u@\h\033[0;m\]::\[\033[1;31m\]\$ret\[\033[0;m\]] [\[\033[1;32m\]\${PWD##*/}\[\033[0;m\]\$(__git_ps1 \"::\[\033[1;34m\]%s\[\033[0;m\]\")] \nλ "
}
PROMPT_COMMAND=prompt_gen

export EDITOR="vim"

export GOPATH="$HOME/workspace/go"
