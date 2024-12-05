#!/usr/bin/env bash

TMUXP_SESSIONS_FILES="/storage/src/devops/tmuxp/notes-and-reminders/fleeting-notes.yml /storage/src/devops/tmuxp/notes-and-reminders/ai-prompts.yml /storage/src/devops/tmuxp/notes-and-reminders/writeloop-raw.yml /storage/src/devops/tmuxp/notes-and-reminders/codex.yml /storage/src/devops/tmuxp/notes-and-reminders/reminders.yml /storage/src/devops/tmuxp/notes-and-reminders/tasks.yml"
tmuxp load $TMUXP_SESSIONS_FILES
