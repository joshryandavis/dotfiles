#!/usr/bin/env bash

killall -9 xdg-desktop-portal-hyprland
killall -9 xdg-desktop-portal-wlr
killall -9 xdg-desktop-portal
killall -9 swaync
killall -9 copyq
killall -9 udiskie
killall -9 nm-applet
killall -9 blueman-applet
killall -9 polkit-kde-authentication-agent-1
killall -9 wayvnc
killall -9 bitwarden
killall -9 thunderbird
killall -9 teams-for-linux
killall -9 electron
killall -9 waybar
killall -9 firefox
killall -9 cider

# wait for waybar to exit
until ! pgrep -f 'waybar'; do sleep 1; done

/usr/lib/xdg-desktop-portal-hyprland &

sleep 2

/usr/lib/xdg-desktop-portal &

until pgrep -f 'xdg-desktop-portal-hyprland'; do sleep 1; done

/usr/lib/polkit-kde-authentication-agent-1 &

until pgrep -f 'polkit-kde-authentication-agent-1'; do sleep 1; done

waybar --config ~/.config/hypr/waybar/config --style ~/.config/hypr/waybar/style.css &

until pgrep -f 'waybar'; do sleep 1; done

sleep 2

copyq --start-server &
udiskie --appindicator &
nm-applet --indicator &
blueman-applet &
wayvnc &
swaync &

firefox &
thunderbird &
bitwarden-desktop &
teams-for-linux &
cider &

sleep 2
notify-send -t 1000 "Hyprland started"