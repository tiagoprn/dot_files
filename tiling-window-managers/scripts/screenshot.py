#!/usr/bin/python3
"""
Call flameshot, to take an image from fullscreen or a region.

Usage:

python screenshot.py -n 'screen/region'

"""

import argparse
import os
import subprocess
import sys
from time import sleep

cli_parser = argparse.ArgumentParser()
cli_parser.add_argument("-s", "--screen", required=True, help="full/region")
args = vars(cli_parser.parse_args())

SCREEN = args['screen']

if SCREEN not in ['full', 'region']:
    print('Invalid value for screen.')
    sys.exit(1)

if __name__ == "__main__":
    flameshot_binary = 'command -v flameshot'

    status_code = subprocess.call(flameshot_binary, shell=True)
    if status_code == 0:
        flameshot_path = 'flameshot'
    else:
        sys.stdout.write('No flameshot binary found. Trying flatpak...')
        flameshot_flatpak = 'flatpak list | grep flameshot'
        status_code = subprocess.call(flameshot_flatpak, shell=True)
        if status_code == 0:
            flameshot_path = (
                'flatpak run --filesystem=host org.flameshot.Flameshot '
            )
        else:
            sys.stderr.write(
                'No flameshot binary or flatpak found. Aborting...'
            )
            exit(1)

    sys.stdout.write(f'flameshot_path = "{flameshot_path}"')

if SCREEN == 'full':
    command = (
        f"notify-send 'Taking screenshot...' --urgency low -t 600; "
        f"mkdir -p ~/screenshots && "
        f"{flameshot_path} full -p ~/screenshots -d 2000"
    )
else:
    command = (
        f"notify-send 'Taking screenshot (CTRL+s to save)...' "
        f"--urgency critical -t 1300; mkdir -p ~/screenshots && "
        f"{flameshot_path} gui -p ~/screenshots -d 2000"
    )

subprocess.call(command, shell=True)
