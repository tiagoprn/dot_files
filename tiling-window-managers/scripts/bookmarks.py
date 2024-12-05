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

BROWSERS = {" Firefox": "firefox", " Chrome": "google-chrome-stable"}

BOOKMARKS_ROOT = "/storage/docs/notes/personal"


def get_bookmark_files():
    return [
        filename
        for filename in glob.iglob(
            f"{BOOKMARKS_ROOT}/**/.BrowserBookmarks", recursive=True
        )
    ]


def get_bookmarks():
    global bookmarks_list, file_context, tag, url
    bookmarks_list = []
    bookmarks_urls = {}
    files = get_bookmark_files()
    for file in files:
        file_context = file.split("/")[-2]
        with open(file, "r") as input_file:
            lines = input_file.readlines()
        for line in lines:
            if line.replace("\n", ""):
                print(f"line={line}")
                tag, url = line.split()
                key = f"{file_context}_{tag}"
                value = url
                bookmarks_list.append(key)
                bookmarks_urls[key] = url
    return sorted(bookmarks_list), bookmarks_urls


if __name__ == "__main__":
    bookmarks_list, bookmarks_urls = get_bookmarks()

    rofi_client = Rofi()
    selected, keyboard_key = rofi_client.select(
        "Choose a bookmark to open", bookmarks_list, fullscreen=True
    )
    logging.info(f"keyboard_key pressed={keyboard_key}")

    if keyboard_key == -1:
        logging.info("cancelled")
        sys.exit(0)

    selected_bookmark = bookmarks_list[selected]
    logging.info(f"selected_bookmark={selected_bookmark}")
    chosen_url = bookmarks_urls[selected_bookmark]
    logging.info(f"chosen_url={chosen_url}")

    command = f'echo "{chosen_url}" |  wl-copy'
    os.system(command)

    browsers = BROWSERS.keys()
    browsers_keys = []
    for index in BROWSERS:
        browsers_keys.append(index)

    selected, keyboard_key = rofi_client.select("Choose a browser", browsers)
    logging.info(f"keyboard_key pressed={keyboard_key}")

    if keyboard_key == -1:
        logging.info("No browser chosen, quitting now.")
        sys.exit(0)

    logging.info(f"selected={selected}")

    selected_browser = BROWSERS[browsers_keys[selected]]
    logging.info(f"selected_browser={selected_browser}")
    command = (
        f'notify-send --urgency low "Opening {selected_browser} '
        f'with url {selected_bookmark}"...'
    )
    os.system(command)

    if "firefox" in selected_browser.lower():
        command = f"{selected_browser} --new-tab {chosen_url} &"
    else:
        command = f"{selected_browser} {chosen_url} &"
    os.system(command)
