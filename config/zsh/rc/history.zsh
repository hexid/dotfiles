SAVEHIST=10000 # Number of entries
HISTSIZE=10000
HISTFILE="$XDG_DATA_HOME"/history # File
setopt APPEND_HISTORY # Don't erase history
#setopt EXTENDED_HISTORY # Add additional data to history like timestamp
setopt INC_APPEND_HISTORY # Add immediately
#setopt HIST_FIND_NO_DUPS # Don't show duplicates in search
setopt HIST_IGNORE_ALL_DUPS # Remove duplicats
setopt HIST_IGNORE_SPACE # Don't preserve spaces. You may want to turn it off
setopt NO_HIST_BEEP # Don't beep
setopt HIST_NO_STORE # Don't history or fc commands
setopt HIST_NO_FUNCTIONS # Don't store function
#setopt SHARE_HISTORY # Share history between session/terminals
