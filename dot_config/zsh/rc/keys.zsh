bindkey -v

autoload zkbd
source ${XDG_CONFIG_HOME:-HOME/.config}/zsh/.zkbd/$TERM-:0

key[Shift+Tab]='\e[Z'

[[ -n ${key[Backspace]} ]] && bindkey "${key[Backspace]}" backward-delete-char
[[ -n ${key[Delete]} ]] && bindkey "${key[Delete]}" forward-delete-char
[[ -n ${key[Insert]} ]] && bindkey "${key[Insert]}" overwrite-mode
[[ -n ${key[Home]} ]] && bindkey "${key[Home]}" beginning-of-line
[[ -n ${key[PageUp]} ]] && bindkey "${key[PageUp]}" history-beginning-search-backward
[[ -n ${key[Delete]} ]] && bindkey "${key[Delete]}" delete-char
[[ -n ${key[End]} ]] && bindkey "${key[End]}" end-of-line
[[ -n ${key[PageDown]} ]] && bindkey "${key[PageDown]}" history-beginning-search-forward
[[ -n ${key[Up]} ]] && bindkey "${key[Up]}" up-line-or-local-history
[[ -n ${key[Left]} ]] && bindkey "${key[Left]}" backward-char
[[ -n ${key[Down]} ]] && bindkey "${key[Down]}" down-line-or-local-history
[[ -n ${key[Right]} ]] && bindkey "${key[Right]}" forward-char
[[ -n ${key[Shift+Tab]} ]] && bindkey "${key[Shift+Tab]}" reverse-menu-complete

autoload edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'v' edit-command-line

# BEGIN local-history-search
# https://superuser.com/a/691603/87238
zstyle ':zle:*-line-or-beginning-search' leave-cursor false

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

up-line-or-local-history() {
	zle set-local-history 1
	#zle up-line-or-history
	zle up-line-or-beginning-search
	zle set-local-history 0
}
down-line-or-local-history() {
	zle set-local-history 1
	#zle down-line-or-history
	zle down-line-or-beginning-search
	zle set-local-history 0
}

zle -N up-line-or-local-history
zle -N down-line-or-local-history
# END local-history-search
