#!/usr/bin/env python3

import glob
import logging
import os
import subprocess
import sys

from rofi import Rofi

CURRENT_SCRIPT_NAME = os.path.splitext(os.path.basename(__file__))[0]
LOG_FORMAT = (
    '[%(asctime)s PID %(process)s '
    '%(filename)s:%(lineno)s - %(funcName)s()] '
    '%(levelname)s -> \n'
    '%(message)s\n'
)
# Configure the logging to console. Works from python 3.3+
logging.basicConfig(
    format=LOG_FORMAT,
    level=logging.INFO,
    handlers=[logging.StreamHandler(sys.stdout)],
)


def run(cmd: str):
    proc = subprocess.Popen(
        cmd,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        shell=True,
        universal_newlines=True,
    )
    std_out, std_err = proc.communicate()
    return proc.returncode, std_out, std_err


def get_layouts_from_dwm_config():
    cheat_sheet_command = (
        "dwm-print-cheatsheet.sh | grep 'dwm:layouts' | "
        "sed 's/MOD/Super_L/g' | awk '{print $2, $4}'"
    )
    return run(cheat_sheet_command)


if __name__ == "__main__":
    layouts = get_layouts_from_dwm_config()[1].split('\n')

    shortcuts = {}
    layout_names = []
    for layout in layouts:
        if layout:
            name, shortcut = layout.split()
            layout_names.append(name)
            shortcuts[name] = shortcut

    rofi_client = Rofi()
    selected, keyboard_key = rofi_client.select(
        'Choose a layout', layout_names
    )
    logging.info(f'keyboard_key pressed={keyboard_key}')

    if keyboard_key == -1:
        logging.info('cancelled')
        rofi_client.exit_with_error('Cancelled, nothing to be done.')

    logging.info(f'selected={selected}')

    selected_name = layout_names[selected]
    shortcut = shortcuts[selected_name]

    notification_command = (
        f'notify-send -u critical -t 2000 "DWM layout successfully changed '
        f'to {selected_name.upper()} ({shortcut})."'
    )

    command = f'xdotool key {shortcut} && {notification_command}'

    logging.info(f'Running command:\n {command}')
    os.system(command)
