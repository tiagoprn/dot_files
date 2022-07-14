#!/usr/bin/env python3

"""
This script reads the file written by ./clippy-capture.py
to select a past clipboard entry from that file, so that
you can put it back on your clipboard.

The idea is to be KISS - no fancy or bloat here.

It uses the tk builtin python library to interact with the keyboard.

It needs the python library "python-rofi" installed to work properly.
"""

import json
import logging
import os
import subprocess
import sys
import tkinter as tk

from rofi import Rofi

CURRENT_SCRIPT_NAME = os.path.splitext(os.path.basename(__file__))[0]
LOG_FILE = f"/tmp/{CURRENT_SCRIPT_NAME}.log"
CLIPBOARD_HISTORY_FILE = f"{os.environ['HOME']}/clipboard.history"

LOG_FORMAT = (
    "[%(asctime)s PID %(process)s "
    "%(filename)s:%(lineno)s - %(funcName)s()] "
    "%(levelname)s -> \n"
    "%(message)s\n"
)
logging.basicConfig(format=LOG_FORMAT)
logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)
logger.propagate = False
fh = logging.FileHandler(LOG_FILE, "a")
fh.setLevel(logging.INFO)
fh.setFormatter(logging.Formatter(LOG_FORMAT))
logger.addHandler(fh)
keep_fds = [fh.stream.fileno()]

history_record_TRUNCATE_SIZE = 50


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


def notify_send(message: str):
    command = f'notify-send --urgency=low "clippy-select.py" "{message}"'
    run(command)


def get_history_file_records():
    logger.info(f"Opening {CLIPBOARD_HISTORY_FILE} to get its records...")

    with open(CLIPBOARD_HISTORY_FILE, "r") as input_file:
        file_records = input_file.readlines()

    logger.info(
        f"Found {len(file_records)} records on {CLIPBOARD_HISTORY_FILE}."
    )

    history_records = []
    for line_number, record in enumerate(file_records, start=1):
        logger.info(f"Parsing line number {line_number}...")
        parsed_record = json.loads(record)
        timestamp = parsed_record["timestamp"]
        contents = parsed_record["contents"]
        if not contents:
            continue
        parsed_record_lines = contents.split("\n")
        first_contents_line = parsed_record_lines[0]
        history_record = first_contents_line[0:history_record_TRUNCATE_SIZE]
        if len(first_contents_line) > history_record_TRUNCATE_SIZE:
            history_record += "..."
        text = "line" if len(parsed_record_lines) == 1 else "lines"
        history_record += f"  --- {len(parsed_record_lines)} {text} "
        history_record += f"from {timestamp}"
        history_records.append(history_record)

    return history_records


def get_paste_contents_from_timestamp(timestamp: str):
    with open(CLIPBOARD_HISTORY_FILE, "r") as input_file:
        file_records = input_file.readlines()

    for record in file_records:
        parsed_record = json.loads(record)
        record_timestamp = parsed_record["timestamp"]
        if record_timestamp == timestamp:
            return parsed_record["contents"]

    raise Exception(f'No record found for timestamp="{timestamp}"')


def copy_to_clipboard(contents: str):
    root = tk.Tk()
    root.withdraw()  # do not show the window
    return root.clipboard_append(contents)


def client():
    logger.info("Running client...")
    print("Showing keyboard selections...")
    history_records = get_history_file_records()
    history_records.reverse()

    rofi_client = Rofi()
    selected, keyboard_key = rofi_client.select(
        "Choose a previous paste from clipboard history",
        history_records,
        fullscreen=True,
    )
    logger.info(f"keyboard_key pressed={keyboard_key}")

    if keyboard_key == -1:
        logger.info("cancelled")
        sys.exit(0)

    selected_paste = history_records[selected]
    logger.info(f"selected_paste={selected_paste}")

    selected_paste_timestamp = selected_paste[-24:]

    contents = get_paste_contents_from_timestamp(selected_paste_timestamp)

    copy_to_clipboard(contents)

    message = f"Paste {selected_paste} successfully copied to clipboard."
    notify_send(message)

    logger.info("Finished running client.")


if __name__ == "__main__":
    try:
        client()
    except Exception as e:
        message = f"An exception was triggered: {e} "
        print(message)
        logger.exception(message)
        sys.exit(1)
