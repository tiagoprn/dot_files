#!/usr/bin/env bash

sudo killall vigiland
# starts the vigiland program in the background and then disassociates it from the terminal, allowing it to continue running independently of the shell session:
vigiland &
disown
