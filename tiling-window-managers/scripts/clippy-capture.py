#!/usr/bin/env python3

"""
This script runs on the gtk loop (recommended to be set when the window manager starts).
It watches the system clipboard, and when a new one arrives it writes it
to a file.

The idea is to be KISS - no fancy or bloat here.

## Ubuntu packages that must be installed to run successfully:

$ sudo apt install python3-gi python3-gi-cairo gir1.2-gtk-3.0 -y

## Gtk clipboard documentation link:

https://developer.gnome.org/pygtk/stable/class-gtkclipboard.html#signal-gtkclipboard--owner-change

"""

import json
import logging
import os
import sys
import tkinter as tk
from datetime import datetime
from subprocess import run

CURRENT_SCRIPT_NAME = os.path.splitext(os.path.basename(__file__))[0]
LOG_FILE = f"/tmp/{CURRENT_SCRIPT_NAME}.log"
PIDFILE = f"/tmp/{CURRENT_SCRIPT_NAME}.pid"
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

DELAY = 1
ROFI_RECORD_TRUNCATE_SIZE = 50


def notify_send(message: str):
    command = f'notify-send --urgency=low "clippy-capture.py" "{message}"'
    run(command, shell=True)


def get_rofi_records():
    with open(CLIPBOARD_HISTORY_FILE, "r") as input_file:
        file_records = input_file.readlines()

    logger.info(
        f"Found {len(file_records)} records on {CLIPBOARD_HISTORY_FILE}."
    )

    rofi_records = []
    for record in file_records:
        parsed_record = json.loads(record)
        timestamp = parsed_record["timestamp"]
        parsed_record_lines = parsed_record["contents"]
        if not parsed_record_lines:
            continue
        parsed_record_lines = parsed_record_lines.split("\n")
        first_contents_line = parsed_record_lines[0]
        rofi_record = first_contents_line[0:ROFI_RECORD_TRUNCATE_SIZE]
        if len(first_contents_line) > ROFI_RECORD_TRUNCATE_SIZE:
            rofi_record += "..."
        text = "line" if len(parsed_record_lines) == 1 else "lines"
        rofi_record += f"  --- {len(parsed_record_lines)} {text} "
        rofi_record += f"from {timestamp}"
        rofi_records.append(rofi_record)

    return rofi_records


def get_paste_contents_from_timestamp(timestamp: str):
    with open(CLIPBOARD_HISTORY_FILE, "r") as input_file:
        file_records = input_file.readlines()

    for record in file_records:
        parsed_record = json.loads(record)
        record_timestamp = parsed_record["timestamp"]
        if record_timestamp == timestamp:
            return parsed_record["contents"]

    raise Exception(f'No record found for timestamp="{timestamp}"')


def get_paste_contents_already_exists_in_history(timestamp: str):
    with open(CLIPBOARD_HISTORY_FILE, "r") as input_file:
        file_records = input_file.readlines()

    for record in file_records:
        parsed_record = json.loads(record)
        record_timestamp = parsed_record["timestamp"]
        if record_timestamp == timestamp:
            return parsed_record["contents"]

    raise Exception(f'No record found for timestamp="{timestamp}"')


def get_last_paste_in_history():
    rofi_records = get_rofi_records()

    try:
        selected_paste = rofi_records[-1]
        selected_paste_timestamp = selected_paste[-24:]
    except:
        return ""

    logger.info(f"last_paste_timestamp={selected_paste_timestamp}")

    return get_paste_contents_from_timestamp(selected_paste_timestamp)


def get_current_paste_on_clipboard() -> str:
    root = tk.Tk()
    root.withdraw()  # do not show the window
    return root.clipboard_get()


def main():
    new_paste = get_current_paste_on_clipboard()

    last_paste = get_last_paste_in_history()

    if new_paste == last_paste:
        logger.info(f"The new paste is already on {CLIPBOARD_HISTORY_FILE}.")
        return

    last_paste = new_paste
    logger.info("New paste found!")
    notify_send("A new paste has been captured.")
    with open(CLIPBOARD_HISTORY_FILE, "a") as output_file:
        timestamp = datetime.now().strftime("%Y%m%d.%H:%M:%S.%f")
        data = {"timestamp": timestamp, "contents": new_paste}
        output_file.write(f"{json.dumps(data)}\n")
        logger.info(
            f"Paste successfully written to file" f"{CLIPBOARD_HISTORY_FILE}"
        )


if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        message = f"An exception was triggered: {e} "
        print(message)
        logger.exception(message)
        sys.exit(1)
