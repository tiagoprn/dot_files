#!/usr/bin/env bash

TMUXP_SESSIONS_FILES="/storage/src/devops/tmuxp/notes-and-reminders/ai-prompts.yml /storage/src/devops/tmuxp/notes-and-reminders/writeloop-raw.yml /storage/src/devops/tmuxp/notes-and-reminders/reminders.yml /storage/src/devops/tmuxp/notes-and-reminders/mindshards.yml /storage/src/devops/tmuxp/notes-and-reminders/tricorder.yml /storage/src/devops/tmuxp/notes-and-reminders/codex.yml"
tmuxp load $TMUXP_SESSIONS_FILES
