#!/bin/bash

sudo -- bash -c "find /opt/src/neovim -name CMakeCache.txt | xargs rm -f"
