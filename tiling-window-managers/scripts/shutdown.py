#!/usr/bin/env python3

import glob
import logging
import os
import sys

from rofi import Rofi

CURRENT_SCRIPT_NAME = os.path.splitext(os.path.basename(__file__))[0]
LOG_FORMAT = (
    "[%(asctime)s PID %(process)s "
    "%(filename)s:%(lineno)s - %(funcName)s()] "
    "%(levelname)s -> \n"
    "%(message)s\n"
)
# Configure the logging to console. Works from python 3.3+
logging.basicConfig(
    format=LOG_FORMAT,
    level=logging.INFO,
    handlers=[logging.StreamHandler(sys.stdout)],
)

ACTIONS = [
    (
        "lock screen",
        "/storage/src/dot_files/tiling-window-managers/scripts/lock-with-betterlockscreen.sh",
    ),
    (
        "standby",
        "xset dpms force standby",
    ),
    (
        "switch user",
        "dm-tool switch-to-greeter",
    ),
    (
        "logoff",
        "/storage/src/dot_files/tiling-window-managers/scripts/logoff.sh",
    ),
    (
        "shutdown",
        "sudo shutdown -h now",
    ),
    (
        "restart",
        "sudo shutdown -r now",
    ),
]


if __name__ == "__main__":
    actions_list = [element[0] for element in ACTIONS]

    rofi_client = Rofi()
    selected, keyboard_key = rofi_client.select(
        "CHOOSE YOUR DESTINY", actions_list
    )
    logging.info(f"keyboard_key pressed={keyboard_key}")

    if keyboard_key == -1:
        logging.info("cancelled")
        rofi_client.exit_with_error("Cancelled, nothing to be done.")

    logging.info(f"selected={selected}")

    command = ACTIONS[selected][1]

    logging.info(f"Running command: {command}")
    os.system(command)
