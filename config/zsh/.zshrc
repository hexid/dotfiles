. "$XDG_CONFIG_HOME"/shell/aliases.sh
if [ -f /usr/share/doc/pkgfile/command-not-found.zsh ]; then
	. /usr/share/doc/pkgfile/command-not-found.zsh
fi

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

if [ command -v direnv &>/dev/null ]; then
	eval "$(direnv hook zsh)"
fi

. "$XDG_CONFIG_HOME"/shell/init.sh
