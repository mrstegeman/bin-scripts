#!/bin/bash

# Check for ffmpeg
ffmpeg_bin=`which ffmpeg | grep -c "ffmpeg"`
if [ $ffmpeg_bin -eq "0" ]; then
    echo "Please install ffmpeg to use this script."
    exit 1
fi

# Check for proper number of arguments
if [ $# -eq 0 -o $# -gt 2 ]; then
    echo "sansa-convert creates videos compatible with a Sandisk e260 series Sansa mp3 player running Rockbox"
    echo
    echo "Usage: $0 [path to input file] [path to output file]"
    exit 1
fi

FFMPEG=`which ffmpeg`
PATH=$1

# Check for valid input path
if [ ! -r "$PATH" ]; then
    echo "Please provide a valid path for your input file."
    exit 1
fi

# Continue normal operation
if [ $# -eq 1 ]; then
    # Only input path provided
    "$FFMPEG" -i "$PATH" -s 220x176 -vcodec mpeg2video -b 200k -ab 192k -ac 2 -ar 44100 -acodec mp3 "$PATH".mpg
    exit 0
else
    # Input and output paths both provided
    OUTPUT=$2
    "$FFMPEG" -i "$PATH" -s 220x176 -vcodec mpeg2video -b 200k -ab 192k -ac 2 -ar 44100 -acodec mp3 "$OUTPUT"
    exit 0
fi

