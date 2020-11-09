export EDITOR=/usr/bin/nvim
export VISUAL=/usr/bin/nvim
export TERMINAL=st

export KEYTIMEOUT=1

export XKB_LAYOUTS='dvorak us'

export GOPATH="$HOME"/workspace/go
export JAVA_HOME=/usr/lib/jvm/default

# disable wine .desktop files
export WINEDLLOVERRIDES='winemenubuilder.exe=d'

export DXVK_HUD='compiler'
# fix issues with shader cache being reset on game launch
export __GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1

# enable VAAPI in Firefox
export MOZ_X11_EGL=1
