#!/bin/bash

pkgdir='/mnt/silverado/pacman/pkg'
exts=('-i686.pkg.tar.xz' '-x86_64.pkg.tar.xz' '-any.pkg.tar.xz')

lastfile=

for ext in "${exts[@]}"; do
    for file in $pkgdir/*$ext; do
        if [ -z "$lastfile" ]; then
            lastfile="$file"
        else
            lastbase=$(basename "$lastfile" "$ext")
            base=$(basename "$file" "$ext")

            lastname=$(echo "$lastbase" | pcregrep -o1 '^(.+?)-\d')
            name=$(echo "$base" | pcregrep -o1 '^(.+?)-\d')

            if [ "$lastname" = "$name" ]; then
                lastver=$(echo "$lastbase" | pcregrep -o1 '^.+?-(\d.+)')
                ver=$(echo "$base" | pcregrep -o1 '^.+?-(\d.+)')

                res=$(vercmp "$lastver" "$ver")
                if [ $res -le 0 ]; then
                    rm "$lastfile"
                    lastfile="$file"
                fi
            else
                lastfile="$file"
            fi
        fi
    done
done
