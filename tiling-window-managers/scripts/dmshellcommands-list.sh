#!/usr/bin/env bash

# Extracts the SHCMD from the dwm-flexipatch config.h, so that I can get a list of the commands that are binded.
# awk hint: $0, here, means the whole line.

AWK_COMMAND='BEGIN {FS="\t"} {shcmd_index=match($0, "SHCMD"); line_length=length($0); chcmd_text=substr($0, shcmd_index, line_length-shcmd_index); print chcmd_text}'

cat /storage/src/dwm-flexipatch/config.h | \
	grep 'SHCMD' | \
	grep -v 'SHCMD(cmd)' | \
	awk "$AWK_COMMAND" | \
	sed 's/ }[\, \*]*$//g' | \
	sort | \
	dmenu -fn 'Jetbrains Mono:size=10' -c -bw 2 -l 20 -p 'DWM SHCMDs: ' | \
	xclip -selection clipboard

