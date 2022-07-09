#!/usr/bin/env python3

# This program is intended to supply a wallpaper that reflects your battery
# charge status. It only required a python 3 installation, with no 3rd party
# libraries, it sticks to python 3 standard library.

# TODO: Extract a cookiecutter template from here for my cli programs.
# TODO: put ipython, ipdb, black, pylint etc and build a container to be able
# to test scripts like this.

# ANSI escape codes (for color support:
# http://www.lihaoyi.com/post/BuildyourownCommandLinewithANSIescapecodes.html)

import logging

from datetime import datetime
from os import getenv, path
from pathlib import Path
from subprocess import check_output, run
from sys import stdout, exit
from time import sleep

# Terminal Colors
RED='\033[1;31m'
BLUE='\033[1;34m'
CYAN='\033[0;36m'
GREEN='\033[1;32m'
WHITE='\033[1;37m'
YELLOW='\033[1;33m'
RESET='\033[0m'

# Logging configuration

LOG_VARS='levelname asctime msecs name funcName lineno processName process message'
LOG_FORMAT = ''
for index, variable in enumerate(LOG_VARS.split()):
    if variable != 'message':
        if index > 0:
            LOG_FORMAT += ':'
        LOG_FORMAT += f'%({variable})s'
    else:
        LOG_FORMAT += f' :: %({variable})s'

logging.basicConfig(format=LOG_FORMAT, stream=stdout, level=logging.DEBUG)

# stdout and command execution related wrappers

def stdout_print(message: str, color: str=WHITE):
    stdout.write(f"{color}{message}{RESET}\n")

def run_and_get_stdout(command: str) -> list:
    result = check_output(command, shell=True)
    return result.decode().split('\n')

# the main script logic

def main():
    # Set wallpaper but do not update the fehbg file.
    SETTER='feh --no-fehbg --bg-scale'
    CRITICAL_BATTERY_PERCENTAGE = 20
    TIME_BETWEEN_CRITICAL_BATTERY_NOTIFICATIONS_IN_SECONDS = 60
    FULLY_CHARGED='/run/battery_fully_charged'

    stdout_print('Executing...', YELLOW)

    DIR = str(Path.cwd())

    first_notification_timestamp = None

    while True:
        command = 'ls /sys/class/power_supply/ | grep -i BAT | head -n 1'
        logging.info(f'Running command >>> {command}...')
        BAT = run_and_get_stdout(command)[0]
        stdout_print(f'BAT={BAT}')

        command=f"cat /sys/class/power_supply/{BAT}/capacity"
        logging.info(f'Running command >>> {command}...')
        BATTERY = run_and_get_stdout(command)[0]
        stdout_print(f'BATTERY={BATTERY}')

        if int(BATTERY) < CRITICAL_BATTERY_PERCENTAGE:
            now = datetime.now()
            if  (not first_notification_timestamp) or \
                    (now - first_notification_timestamp).seconds > \
                    TIME_BETWEEN_CRITICAL_BATTERY_NOTIFICATIONS_IN_SECONDS:
                command = (f'notify-send -u critical -t 5000 "Battery level '
                        f'critical, connect AC power as soon as possible..."')
                logging.info(f'Running command >>> {command}...')
                run_and_get_stdout(command)[0]
                first_notification_timestamp = datetime.now()

        command="ls /sys/class/power_supply/ | grep -i AC | head -n 1"
        logging.info(f'Running command >>> {command}...')
        AC = run_and_get_stdout(command)[0]
        stdout_print(f'AC={AC}')

        command=f"cat /sys/class/power_supply/{AC}/online"
        logging.info(f'Running command >>> {command}...')
        CHARGE = run_and_get_stdout(command)[0]
        stdout_print(f'CHARGE={CHARGE}')

        if int(CHARGE) == 1 and int(BATTERY) < 100:  # animate
            if path.exists(FULLY_CHARGED):
                logging.info(f'Battery is not fully charged anymore, '
                             f'so removing lock file...')
                command = f'sudo rm -fr {FULLY_CHARGED}'
                logging.info(f'Running command >>> {command}...')
                run_and_get_stdout(command)[0]

            logging.info('Animating...')
            for i in range(1, 6):
                command = f'{SETTER} {DIR}/images/charge_{i}.png'
                logging.info(f'Running command >>> {command}...')
                run_and_get_stdout(command)[0]
                sleep(0.8)

        elif int(CHARGE) == 1 and int(BATTERY) == 100:  # stop animation when fully charged
            if path.exists(FULLY_CHARGED):
                sleep(60)
                continue

            logging.info('Fully charged, finishing and wrapping up...')
            command = (f'notify-send "Battery fully charged, '
                    f'returning to the original wallpaper now."')
            logging.info(f'Running command >>> {command}...')
            run_and_get_stdout(command)[0]
            command = ('/storage/src/devops/bin/i3_change_wallpaper.sh')
            logging.info(f'Running command >>> {command}...')
            run_and_get_stdout(command)[0]

            logging.info(f'Creating the lock file since '
                         f'battery is fully charged.')
            command = f'sudo touch {FULLY_CHARGED}'
            logging.info(f'Running command >>> {command}...')
            run_and_get_stdout(command)[0]

        else:  # change according to the battery percentage
            if path.exists(FULLY_CHARGED):
                logging.info(f'Battery is not fully charged anymore, '
                             f'so removing lock file...')
                command = f'sudo rm -fr {FULLY_CHARGED}'
                logging.info(f'Running command >>> {command}...')
                run_and_get_stdout(command)[0]
            logging.info('Changing to the battery percentage...')
            num = int(int(BATTERY) / 20)
            logging.info(f'num={num}')
            command = f'{SETTER} {DIR}/images/battery_{num}.png'
            logging.info(f'Running command >>> {command}...')
            run_and_get_stdout(command)[0]
            sleep(5)

    stdout_print('Finished. :)', GREEN)

if __name__ == '__main__':
    main()

