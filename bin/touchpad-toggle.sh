#!/usr/bin/env sh
# Toggle touchpad

synclient TouchpadOff=$(synclient -l | grep -c 'TouchpadOff.*=.*0')
