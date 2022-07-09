#!/usr/bin/env bash

urxvt --hold --title flashcard -e /bin/bash -c 'fortune -u -e -c /storage/src/fortunes/ | tail +3 | cowsay -b -f dragon -W 80' &
