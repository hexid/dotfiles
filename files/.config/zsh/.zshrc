autoload -U colors && colors

source $HOME/.config/aliases

unsetopt beep

for f in $ZDOTDIR/rc/*; do
	source $f
done

zstyle :compinstall filename '/home/hexid/.zsh/zshrc'
autoload -Uz compinit
compinit
