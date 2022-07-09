#!/usr/bin/env python3

import glob
import logging
import os
import sys

from rofi import Rofi

CURRENT_SCRIPT_NAME = os.path.splitext(os.path.basename(__file__))[0]
LOG_FORMAT = ('[%(asctime)s PID %(process)s '
              '%(filename)s:%(lineno)s - %(funcName)s()] '
              '%(levelname)s -> \n'
              '%(message)s\n')
# Configure the logging to console. Works from python 3.3+
logging.basicConfig(
    format=LOG_FORMAT,
    level=logging.INFO,
    handlers=[logging.StreamHandler(sys.stdout)]
)

SCRIPTS_PATH = '/storage/src/devops/shellscripts/utils'

ACTIONS = [
    ('br-abnt2', f'{SCRIPTS_PATH}/setxkbmap_brasil_abnt2.sh',),
    ('us-international', f'{SCRIPTS_PATH}/setxkbmap_us_with_dead_keys.sh',),
]


if __name__ == "__main__":
    actions_list = [element[0] for element in ACTIONS]

    rofi_client = Rofi()
    selected, keyboard_key = rofi_client.select(
        'Choose a keyboard layout',
        actions_list
    )
    logging.info(f'keyboard_key pressed={keyboard_key}')

    if keyboard_key == -1:
        logging.info('cancelled')
        rofi_client.exit_with_error('Cancelled, nothing to be done.')

    logging.info(f'selected={selected}')

    command = ACTIONS[selected][1]

    logging.info(f'Running command: {command}')
    os.system(command)
