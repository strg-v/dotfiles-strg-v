#!/bin/bash

DEVICE="uniw0001:00-093a:0255-touchpad"
STATEFILE="/tmp/touchpad_enabled"

if [ -f "$STATEFILE" ]; then
    hyprctl keyword "device[$DEVICE]:enabled" false
    rm "$STATEFILE"
    notify-send "Touchpad disabled"
else
    hyprctl keyword "device[$DEVICE]:enabled" true
    touch "$STATEFILE"
    notify-send "Touchpad enabled"
fi
