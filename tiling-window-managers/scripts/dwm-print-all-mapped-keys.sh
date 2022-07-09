#!/bin/bash

dwm-print-cheatsheet.sh | cut -d '=' -f 2 | cut -d '>' -f 2 | cut -d ' ' -f 2 | sort
