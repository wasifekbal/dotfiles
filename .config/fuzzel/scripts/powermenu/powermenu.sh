#!/bin/bash

# Options
poweroff=' Poweroff';
reboot=' Reboot';
hard_reboot=" Hard reboot"
firmware='󰍛 Firmware';
lock=' Lock';
suspend='󰒲 Suspend';
logout='󰍃 Logout';

uptime=$(uptime -p | cut -b 4- -)
options="$poweroff\n$reboot\n$hard_reboot\n$firmware\n$lock\n$suspend\n$logout"
option_length="$(echo -e "$options" | wc -l)"

# choice=$(echo -e $options | fuzzel --dmenu -l $option_length -p "[Uptime: $uptime]  ");
choice=$(echo -e $options | fuzzel --dmenu -l $option_length -p " ");

case "$choice" in
    $poweroff) poweroff ;;
    $reboot) reboot ;;
    $hard_reboot) pkexec "echo b > /proc/sysrq-trigger";;
    $firmware) systemctl reboot --firmware-setup;;
    $lock) xdg-screensaver lock ;;
    $suspend) systemctl suspend ;;
    $logout) pkill -KILL -u $(whoami);;
    *) exit 1 ;;
esac
