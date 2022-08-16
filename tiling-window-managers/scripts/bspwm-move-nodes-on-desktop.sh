#!/bin/bash

self_name=$(basename "$0")

usage() {
    echo "---"
    echo -e "Move windows [f]rom desktop x [t]o desktop y.\n"
    echo -e "USAGE: \n\t$self_name -f [desktop-number] -t [desktop-number]"
}

while getopts ":f:t:" arg; do
    case $arg in
        f) FROM=$OPTARG ;;
        t) TO=$OPTARG ;;
        ?)
            echo "Invalid option: -${OPTARG}"
            usage
            exit 2
            ;;
    esac
done

if [[ (-z ${FROM+set}) || (-z ${TO+set}) ]]; then
    usage
    exit 1
fi

echo -e "FROM=$FROM"
echo -e "TO=$TO"

nodes=$(bspc query -N -d "$FROM" | tr '\n' ' ')

for node_id in $nodes; do
    echo -e "Moving $node_id from desktop $FROM to desktop $TO..."
    bspc node "$node_id" -d "$TO"
done
