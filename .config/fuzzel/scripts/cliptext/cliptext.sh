#!/bin/bash

CLIPTEXT_DIR="$HOME/.local/cliptext"
CLIPTEXT_FILE="$CLIPTEXT_DIR/cliptext.txt"

if [ ! -d $CLIPTEXT_DIR ]; then
    mkdir -p $CLIPTEXT_DIR;
fi

if [ ! -f $CLIPTEXT_FILE ]; then
    /usr/bin/touch $CLIPTEXT_FILE;
fi

clips=$(tac $CLIPTEXT_FILE);
option_length="$(echo -e "$clips" | wc -l)"

selected_clip=$( echo -e "$clips" | fuzzel --dmenu -l $option_length -p " " --placeholder "**************")

if [ "$selected_clip" = "" ]; then
    exit 0;
fi

echo $selected_clip | wl-copy
# wtype type $selected_clip;
# wtype key KP_Enter;
