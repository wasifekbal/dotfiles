#!/bin/bash

if [[ -f /usr/bin/rofi ]]; then
    ROFI_PATH="/usr/bin/rofi";
elif [[ -f /usr/local/bin/rofi ]]; then
    ROFI_PATH="/usr/local/bin/rofi";
elif [[ -f $HOME/.local/bin/rofi ]]; then
    ROFI_PATH="$HOME/.local/bin/rofi";
else
    ROFI_PATH="";
fi

if [[ $ROFI_PATH != "" ]]; then
    $ROFI_PATH -show emoji -theme-str 'listview { lines: 15; columns: 1; }'
else
    /usr/bin/notify-send -i error-hand-64 -t 4000 "Unable to find ROFI";
fi

