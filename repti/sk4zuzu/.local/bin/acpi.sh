#!/usr/bin/env bash

: ${INTERVAL:=60}
: ${TIMEOUT:=59000}
: ${THRESHOLD:=10}

set -o errexit -o nounset -o pipefail

# Assert that all required tools are installed.
which acpitool head tr grep notify-send dunst sleep

while :; do
    # Extract and clean (tr -s ' ' squeezes multiple spaces) the #1 battery status and skip if not discharging.
    if OUTPUT=$(acpitool -b | head -n1 | tr -s ' ') && [[ "$OUTPUT" == *Discharging* ]]; then
        # Extract the #1 battery percentage and skip if below threshold.
        if PERCENT=$(grep -m1 -oP '\d+(?=\.\d+%)' <<< "$OUTPUT") && [[ "$PERCENT" -lt "$THRESHOLD" ]]; then
            # Send notification to the dunst daemon
            notify-send --urgency critical --expire-time "$TIMEOUT" "$OUTPUT"
        fi
    fi
    sleep "$INTERVAL"
done
