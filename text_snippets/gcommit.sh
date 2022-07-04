#!/bin/bash

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

printf "g c -m 'feat: updated repository on $TIMESTAMP' && g ps"
