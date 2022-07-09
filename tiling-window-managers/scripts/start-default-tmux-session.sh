#!/bin/bash

NAME='default'

notify-send --urgency low "Starting tmux session $NAME on terminal..."

TMUXP="tmuxp"

if [ -z "$TMUXP" ]; then
  TMUXP='tmuxp'

  if [ -z "$TMUXP" ]; then
    echo missing tmuxp, please install to proceed.
    exit 1
  fi

fi

$TMUXP load /storage/src/devops/tmuxp/default-wide.yml

