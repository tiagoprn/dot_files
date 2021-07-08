#!/usr/bin/env bash

set -eou pipefail

usage()
{
	echo "usage: script.sh -p value"
}

no_args="true"
while getopts ":p:" arg; do
  case $arg in
    p) VALUE=$OPTARG;;
  esac
  no_args="false"
done

[[ "$no_args" == "true" ]] && { usage; exit 1; }

echo -e "VALUE=$VALUE"

