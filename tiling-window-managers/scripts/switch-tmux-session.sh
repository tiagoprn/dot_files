#!/bin/bash

# Use tv (televisiov) to select a tmux session to switch to

tv tmux-sessions | xargs -I {} tmux switch-client -t {}
