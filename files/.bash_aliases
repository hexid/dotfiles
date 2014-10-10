alias dir='dir --color=auto'
alias dmesg='dmesg --color=auto'
alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias ll='ls -lAh'
alias rm='echo | xargs -p rm'

alias pycalc='python -ic "from math import *"'

alias clip='xsel --clipboard --input <'

alias subl3='subl3 -n'

alias steam-wine-nodebug='env WINEDEBUG=-all WINEPREFIX=~/.wine-steam wine ~/.wine-steam/drive_c/Program\ Files\ \(x86\)/Steam/Steam.exe >/dev/null'
alias steam-wine='env WINEPREFIX=~/.wine-steam wine ~/.wine-steam/drive_c/Program\ Files\ \(x86\)/Steam/Steam.exe'
