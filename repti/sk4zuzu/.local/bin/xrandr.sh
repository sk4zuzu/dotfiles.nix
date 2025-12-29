#!/usr/bin/env bash

: "${GPU:=1}"

set -o errexit

if type -p doas tee; then
    if [[ -f "/sys/class/drm/card$GPU/device/power_dpm_force_performance_level" ]]; then
        doas tee "/sys/class/drm/card$GPU/device/power_dpm_force_performance_level" <<< 'low'
    fi
    if [[ -f "/sys/class/backlight/amdgpu_bl$GPU/brightness" ]]; then
        doas tee "/sys/class/backlight/amdgpu_bl$GPU/brightness" < "/sys/class/backlight/amdgpu_bl$GPU/max_brightness"
    fi
fi

if type -p hsetroot; then
    hsetroot -solid '#000000'
fi

if type -p xrandr; then
    XRANDR_STATE="$(xrandr --query)"
    if [[ "$XRANDR_STATE" =~ (^|[[:space:]])eDP([[:space:]]|$) ]]; then
        xrandr --output 'eDP' --mode '1920x1080'
        if [[ "$XRANDR_STATE" =~ (^|[[:space:]])HDMI-A-0([[:space:]]|$) ]]; then
            xrandr --output 'HDMI-A-0' --same-as 'eDP' --mode '1920x1080'
        fi
    fi
fi
