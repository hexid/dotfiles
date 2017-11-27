. "$XDG_CONFIG_HOME"/shell/aliases.sh
. /usr/share/doc/pkgfile/command-not-found.zsh

unsetopt beep

setopt COMPLETE_ALIASES
setopt correct
setopt globdots

for f in $ZDOTDIR/rc/*; do
	. $f
done

# enable completion
zstyle :compinstall filename "$XDG_CONFIG_HOME"/zsh/.zshrc
autoload -Uz compinit
compinit -d "$XDG_CACHE_HOME"/zcompdump

. "$XDG_CONFIG_HOME"/shell/init.sh
