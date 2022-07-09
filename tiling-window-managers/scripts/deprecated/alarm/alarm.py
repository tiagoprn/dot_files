#!/usr/bin/env python3

import glob
import logging
import os
import subprocess
import sys
from datetime import datetime
from time import sleep


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

CALENDARS_ROOT = '/storage/docs/notes'
WAKE_UP_INTERVAL_IN_SECONDS=15

def _get_current_timestamp():
    return datetime.now().strftime('%Y-%m-%d %H:%M')


def get_calendar_files():
    return [filename for filename in \
            glob.iglob(f'{CALENDARS_ROOT}/**/.calendar.txt',
                       recursive=True)]


def get_file_lines(file):
    file_context = file.split('/')[-2]
    logging.info(f'file_context={file_context}')
    with open(file, 'r') as input_file:
        return input_file.readlines()


def get_trigger_alarm_now(line):
    current_timestamp = _get_current_timestamp()
    current_time = current_timestamp.split()[1]
    logging.info(f'current_time={current_time}')
    logging.info(f'current_timestamp={current_timestamp}')

    line_elements = line.strip().split()
    time_elements = []
    event_description_end_index = -1
    for index, element in enumerate(line_elements):
        if element.startswith('@') or element[0].isdigit():
            if event_description_end_index == -1:
                event_description_end_index = index-1
            time_elements.append(element)

    len_time_elements = len(time_elements)
    if len_time_elements == 4:
        trigger_time = time_elements[1]
        frequency = time_elements[2][1:]
        alarm_at = time_elements[3][1:]
        logging.info(f'trigger_time={trigger_time}, '
                        f'frequency={frequency}, '
                        f'alarm_at={alarm_at}')
        if frequency == 'daily' and trigger_time == current_time:
            logging.info('Time to trigger alarm.')
            event_name_elements = line_elements[:event_description_end_index+1]
            return ' '.join(event_name_elements[1:])

    logging.info('Now is not time to trigger the alarm.')
    return ''

def run_command(event):
    command = f'notify-send --urgency critical "ALARM: {event}"'
    logging.info(f'command={command}')
    result = subprocess.run(command.split(), stdout=subprocess.PIPE)
    return result.stdout.decode()

def trigger_notification(event):
    logging.info(f'event={event}')
    stdout = run_command(event)
    logging.info(f'Execution result={stdout}')

def process_file(file):
    for line in get_file_lines(file):
        event = get_trigger_alarm_now(line)
        if event:
            trigger_notification(event)


def process_files():
    files = get_calendar_files()
    for file in files:
        process_file(file)

if __name__ == "__main__":
    while True:
        sleep(WAKE_UP_INTERVAL_IN_SECONDS)
        process_files()

