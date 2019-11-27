#!/bin/sh
sudo apt install alsa-tools
sudo hda-verb /dev/snd/hwC0D0 0x1d SET_PIN_WIDGET_CONTROL 0x0
