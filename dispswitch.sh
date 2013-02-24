#!/bin/bash

INT="LVDS1"
EXT="HDMI1"

if (xrandr | grep "$EXT" | grep "+")
then
    xrandr --output "$EXT" --off --output "$INT" --auto
else
    if (xrandr | grep "$EXT connected")
    then
        xrandr --output "$INT" --primary --output "$EXT" --auto --left-of "$INT"
    fi
fi
