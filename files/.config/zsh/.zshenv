export EDITOR='/usr/bin/vim'
export VISUAL='/usr/bin/vim'

export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"

export VIMINIT='let $MYVIMRC="${XDG_CONFIG_HOME:-$HOME/.config}/vim/vimrc" | source $MYVIMRC'

systemctl --user set-environment XDG_VTNR=1
