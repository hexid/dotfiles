export EDITOR='/usr/bin/vim'
export VISUAL='/usr/bin/vim'

export PKGBUILDDIR="$HOME/workspace/packages"

export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"

export VIMINIT='if empty($XDG_CONFIG_HOME) | let $XDG_CONFIG_HOME="$HOME/.config" | endif | let $MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc" | source $MYVIMRC'

export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"

systemctl --user set-environment XDG_VTNR=1
systemctl --user import-environment GNUPGHOME
