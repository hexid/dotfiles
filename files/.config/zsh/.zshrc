autoload -U colors && colors

source $HOME/.config/aliases

export PATH=$PATH:$HOME/.local/bin

unsetopt beep

for f in $ZDOTDIR/rc/*; do
	source $f
done

zstyle :compinstall filename "$HOME/.zsh/zshrc"
autoload -Uz compinit
compinit
