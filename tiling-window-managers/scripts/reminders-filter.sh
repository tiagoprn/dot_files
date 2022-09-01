#!/bin/bash

self_name=$(basename "")

usage() {
    echo "---"
    echo -e "Filter reminders from given date.\n"
    echo -e "USAGE: \n\t$self_name -d [YYYY/MM/DD]"
}

while getopts ":d:" arg; do
    case $arg in
        d) DATE=$OPTARG ;;
        ?)
            echo "Invalid option: -$OPTARG"
            usage
            exit 2
            ;;
    esac
done

if [[ -z ${DATE+set} ]]; then
    usage
    exit 1
fi

echo -e "DATE=$DATE"

remind -s /storage/docs/reminders/personal.rem | grep "$DATE" | cut -f 6- -d ' '

echo 'DONE'
