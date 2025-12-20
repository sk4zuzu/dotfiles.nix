#!/usr/bin/env bash

: ${GPU:=1}

set -o errexit -o nounset -o pipefail

if [[ -f /sys/class/drm/card$GPU/device/power_dpm_force_performance_level ]]; then
    doas tee /sys/class/drm/card$GPU/device/power_dpm_force_performance_level <<< low
fi

if [[ -f /sys/class/backlight/amdgpu_bl$GPU/brightness ]]; then
    doas tee /sys/class/backlight/amdgpu_bl$GPU/brightness < /sys/class/backlight/amdgpu_bl$GPU/max_brightness
fi

if which hsetroot; then
    hsetroot -solid '#000000'
fi

if which xrandr; then
    if xrandr | grep eDP; then
        xrandr --output eDP --auto
        if xrandr | grep HDMI-A-0; then
            xrandr --output HDMI-A-0 --same-as eDP --mode 1920x1080
        fi
    fi
fi
