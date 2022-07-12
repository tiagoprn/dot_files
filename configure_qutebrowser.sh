#!/bin/bash
QUTEBROWSER_CONFIG_ROOT="$HOME/.local/share/qutebrowser/personal"
rm -fr "$QUTEBROWSER_CONFIG_ROOT"
mkdir -p "$QUTEBROWSER_CONFIG_ROOT/config" || true
ln -s /storage/src/dot_files/qutebrowser/config.py "$QUTEBROWSER_CONFIG_ROOT/config/config.py"
