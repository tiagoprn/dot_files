#!/bin/bash

/usr/bin/flatpak run --branch=stable --arch=x86_64 --command=/app/bin/qutebrowser org.qutebrowser.qutebrowser "$@"
