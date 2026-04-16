#!/bin/bash

# Options
poweroff=' Poweroff';
reboot=' Reboot';
lock=' Lock';
suspend='󰒲 Suspend';
logout='󰍃 Logout';


ROFI_THEME="~/.config/rofi/scripts/powermenu/power.rasi"

uptime=$(uptime -p | cut -b 4- -)
options="$poweroff\n$reboot\n$lock\n$suspend\n$logout"

choice=$(echo -e $options | rofi -dmenu -p "  " -mesg "Uptime: $uptime" -i -theme $ROFI_THEME);

case "$choice" in
  $poweroff) poweroff ;;
  $reboot) reboot ;;
  $lock)
      if which "screenlock" >/dev/null 2>&1 && which "betterlockscreen" >/dev/null 2>&1; then
          screenlock;
      else
          xdg-screensaver lock
      fi
  ;;
  $suspend) systemctl suspend ;;
  $logout) pkill -KILL -u $(whoami);;
  *) exit 1 ;;
esac
