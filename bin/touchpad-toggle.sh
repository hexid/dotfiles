#!/usr/bin/env bash
# Toggle touchpad

synclient TouchpadOff=$(synclient -l | grep -c 'TouchpadOff.*=.*0')
