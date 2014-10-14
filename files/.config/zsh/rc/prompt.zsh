setopt prompt_subst

if [ $UID -eq 0 ]; then usercolor="red"; else usercolor="green"; fi

#local fill='$(printf "%${COLUMNS}s\n" | sed "s/ /─/g")'
local user_host="[%{$fg_bold[$usercolor]%}%n%{$reset_color%}@%{$fg_bold[yellow]%}%m%{$reset_color%}]"
local cmd_return="%(?..─[%{$fg_bold[red]%}%?%{$reset_color%}])"
local curr_dir="[%{$fg_bold[blue]%}%~%{$reset_color%}]"
#PROMPT="${fill}%{"$'\r''%}${user_host}%{'$'\e[1C''%}${curr_dir}%{'$'\e[1C''%}${cmd_return}%{'$'\n''λ %}'
PROMPT='${user_host}─${curr_dir}${cmd_return}'$'\n''λ '

