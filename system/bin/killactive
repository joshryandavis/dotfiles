#!/bin/sh

classes=("Steam")

active_class=$(hyprctl activewindow -j | jq -r ".class")

if [[ " ${classes[@]} " =~ " ${active_class} " ]]; then
    xdotool getactivewindow windowunmap
else
    hyprctl dispatch killactive ""
fi