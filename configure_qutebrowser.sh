#!/bin/bash
mkdir -p ~/.local/share/qutebrowser/personal || true
mkdir -p ~/.local/share/qutebrowser/work/dafiti || true
ln -s /storage/src/dot_files/qutebrowser/config.py ~/.local/share/qutebrowser/personal/config/config.py
ln -s /storage/src/dot_files/qutebrowser/config.py ~/.local/share/qutebrowser/work/dafiti/config/config.py
