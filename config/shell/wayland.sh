#!/usr/bin/env sh

unset WAYLAND_DISPLAY

export SDL_VIDEODRIVER=wayland
export QT_QPA_PLATFORM=wayland
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
