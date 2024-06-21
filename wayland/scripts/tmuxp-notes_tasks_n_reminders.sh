#!/usr/bin/env bash

TMUXP_SESSIONS_FILES="/storage/src/nix/home/tmuxp/fleeting-notes.yml /storage/src/nix/home/tmuxp/reminders.yml /storage/src/nix/home/tmuxp/tasks.yml"

tmuxp load $TMUXP_SESSIONS_FILES
