#!/bin/bash

alphanum=0
num=0

while getopts "an:" opt; do
    case $opt in
        a)
            alphanum=1
            ;;
        n)
            num=$OPTARG
            ;;
        \?)
            echo -e "Invalid option: -$OPTARG\n" >&2
            ;;
        :)
            echo -e "Option -$OPTARG requires an argument.\n" >&2
            ;;
    esac
done

chars=(a b c d e f g h i j k l m n o p q r s t u v w x y z
       A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
       1 2 3 4 5 6 7 8 9 0)

if [ $alphanum -eq 0 ]; then
    chars=("${chars[@]}" \` \~ \! \@ \# \$ \% \^ \& \* \( \) \- \_
            \+ \= \[ \{ \] \} \\ \| \; \: \' \" \< \> \? \, \. \/)
fi

for (( i=0; i<$num; i++ ))
do
    number=$RANDOM
    let "number %= ${#chars[@]}"
    echo -n "${chars[$number]}"
done
echo
