typeset -U path
path=("${GOPATH//://bin:}" $path[@])

[ -f ~/.config/shell/xdg.sh ] && . ~/.config/shell/xdg.sh
