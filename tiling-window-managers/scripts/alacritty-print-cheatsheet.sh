#!/bin/bash

cat /storage/src/dot_files/alacritty/alacritty.yml | grep '(binding:' | sed 's/mode: Vi, //g' | sed 's/- { //g' | sed 's/action: /# /g' | sed 's/}  # (binding: /(/g' | sed 's/,//g' | sed 's/mods/, mods/g' | sed 's/ \+/ /g' | column -s '#' -t
