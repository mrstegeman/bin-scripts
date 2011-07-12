#!/bin/bash

usage() {
    echo "A simple random password generator"
    echo "Usage: $(basename "$0") [OPTION]... -n <num>"
    cat <<EOF

Options:
    -a          Use alpha-numeric characters only
    -h          Print this message and exit
    -n <num>    Number of characters in password
EOF
}

alphanum=0
num=0

while getopts "ahn:" opt; do
    case $opt in
        a)
            alphanum=1
            ;;
        n)
            num=$OPTARG
            ;;
        h)
            usage
            exit 0
            ;;
        \?)
            echo -e "Invalid option: -$OPTARG\n" >&2
            ;;
        :)
            echo -e "Option -$OPTARG requires an argument.\n" >&2
            ;;
    esac
done

if [ $num -eq 0 ]; then
    usage
    exit 1
fi

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
