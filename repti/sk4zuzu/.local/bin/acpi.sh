#!/usr/bin/env bash

: "${BAT:=0}"
: "${STATUS_PATH:=/sys/class/power_supply/BAT$BAT/status}"
: "${CAPACITY_PATH:=/sys/class/power_supply/BAT$BAT/capacity}"

: "${INTERVAL:=60}"
: "${TIMEOUT:=59000}"
: "${THRESHOLD:=10}"

set -o errexit

# Assert that all required status files are readable.
[[ -r "$STATUS_PATH" ]] && [[ -r "$CAPACITY_PATH" ]]

# Assert that all required tools are installed.
type -p notify-send sleep

while :; do
    # Get battery status and skip if not discharging.
    if read -r STATUS < "$STATUS_PATH" && [[ "$STATUS" =~ (^|[[:space:]])Discharging([[:space:]]|$) ]]; then
        # Get battery capacity (%) and skip if below threshold.
        if read -r CAPACITY < "$CAPACITY_PATH" && [[ "$CAPACITY" -lt "$THRESHOLD" ]]; then
            # Send notification to the dunst daemon
            notify-send --urgency critical --expire-time "$TIMEOUT" "BAT #$BAT $STATUS $CAPACITY%"
        fi
    fi
    sleep "$INTERVAL"
done
