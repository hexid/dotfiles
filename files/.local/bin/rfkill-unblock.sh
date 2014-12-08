#!/usr/bin/env bash
# Unblocks RKFILL for devices
# To view blocked devices: `sudo rfkill list all`

sudo rfkill unblock all
