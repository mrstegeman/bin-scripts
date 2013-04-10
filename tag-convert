#!/bin/bash

function rename_mp3 {
    eyeD3 -v "$1" | pcregrep -q '<Track\snumber\/Position\sin\sset\s\(TRCK\):\s(\d+)'
    if [ $? -eq 0 ]; then
        eyeD3 --to-v2.3 --rename="%n - %t" "$1"
    else
        eyeD3 --track=0 --to-v2.3 --rename="00 - %t" "$1"
    fi
}

find "$1" -type f -iname '*.mp3' -print0 | while read -d $'\0' mp3
do
    rename_mp3 "$mp3"
done
