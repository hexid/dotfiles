#!/usr/bin/env bash

touch /tmp/need-reboot

herbstclient emit_hook reboot
