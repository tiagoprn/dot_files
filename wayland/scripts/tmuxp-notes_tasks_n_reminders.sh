#!/usr/bin/env bash

TMUXP_SESSIONS_FILES="/storage/src/devops/tmuxp/notes-and-reminders/ai-prompts.yml /storage/src/devops/tmuxp/notes-and-reminders/writeloop-raw.yml /storage/src/devops/tmuxp/notes-and-reminders/reminders.yml /storage/src/devops/tmuxp/notes-and-reminders/mindshards.yml /storage/src/devops/tmuxp/notes-and-reminders/tricorder.yml /storage/src/devops/tmuxp/notes-and-reminders/codex.yml /storage/src/devops/tmuxp/tng-bridge.yml /storage/src/devops/tmuxp/notes-and-reminders/qntuum.yml /storage/src/devops/tmuxp/notes-and-reminders/pi-session.yml"
tmuxp load $TMUXP_SESSIONS_FILES -y
