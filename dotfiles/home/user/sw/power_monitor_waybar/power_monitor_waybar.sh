#!/bin/bash

#   Author: strg-v
#   Date: 2025-06-04
#
#   Usage example:
#   ./power_monitor_waybar /sys/class/power_supply/BAT0

BASE_PATH="$1"

CURRENT_UA=$(cat ${BASE_PATH}/current_now)
VOLTAGE_UV=$(cat ${BASE_PATH}/voltage_now)

STATUS=$(cat ${BASE_PATH}/status)
MULTIPLIER=""

if [ "$STATUS" = "Charging" ]; then
MULTIPLIER="+"
elif [ "$STATUS" = "Discharging" ]; then
MULTIPLIER="-"
elif [ "$STATUS" = "Not charging" ]; then
MULTIPLIER="-"
else
MULTIPLIER="-"
fi


POWER_UW=$((CURRENT_UA*VOLTAGE_UV))

POWER_W=$(awk "BEGIN {printf \"%.1f\", $POWER_UW / 1000000000000}")

echo { \"text\": \"${MULTIPLIER}${POWER_W}W\" }