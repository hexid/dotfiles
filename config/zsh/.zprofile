typeset -U path
path=("${GOPATH//://bin:}/bin" $path[@])

[ -f ~/.config/shell/xdg.sh ] && . ~/.config/shell/xdg.sh
