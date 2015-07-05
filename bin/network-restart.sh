#!/usr/bin/env sh
# Restart network

sudo systemctl restart systemd-networkd.service
sudo systemctl restart wpa_supplicant@wlp3s0.service
