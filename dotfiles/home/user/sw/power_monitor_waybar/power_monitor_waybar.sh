#!/bin/bash

#   Author: strg-v
#   Date: 2025-06-04
#   
#   Requires upower for remaining battery in tooltip field
#
#   argument 1: path to /sys/class/power_supply/[...] device with current_now and voltage_now files
#   optional argument 2: "org-path", to upower device stating remaining battery duration
#
#   Usage example:
#   ./power_monitor_waybar.sh /sys/class/power_supply/BAT0 /org/freedesktop/UPower/devices/battery_BAT0

BASE_PATH="$1"
REMAINING_BATTERY_PATH="$2"

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

REMAINING_BATTERY=""

if [ -z $REMAINING_BATTERY_PATH ]; then

echo { \"text\": \"${MULTIPLIER}${POWER_W}W\", \"tooltip\": \"${REMAINING_BATTERY}\" }
exit 0

else

LINE=$(upower -i $REMAINING_BATTERY_PATH | grep "time to empty")

LINE=${LINE//"time to empty:"}
LINE=${LINE//" "}
LINE=${LINE//","/"."}

UNIT=""

if [[ $LINE =~ "hours" ]]; then
LINE=${LINE//"hours"}
UNIT="h"
REMAINING_BATTERY=$LINE$UNIT

elif [[ $LINE =~ "minutes" ]]; then
LINE=${LINE//"minutes"}
UNIT="min"
REMAINING_BATTERY="<span color=\\\"#FF9F1C\\\">"$LINE$UNIT"</span>"
fi


echo { \"text\": \"${MULTIPLIER}${POWER_W}W\", \"alt\": \"${REMAINING_BATTERY}\" }
exit 0

fi

