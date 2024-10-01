setopt prompt_subst

autoload -Uz vcs_info
zstyle ':vcs_info:git*' formats "%K{2} %b%m%u%c "

local user="%K{19} %n "
local cmd_return="%(?..%K{1} %? )"
local curr_dir="%K{4} %4(~:.../:)%3~ "

precmd() {
	vcs_info
}

PROMPT="${user}%F{0}${cmd_return}${curr_dir}\${vcs_info_msg_0_}%f%k
λ "
