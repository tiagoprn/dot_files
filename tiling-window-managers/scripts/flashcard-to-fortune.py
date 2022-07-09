#!/usr/bin/env python3

"""
Given a text file formatted as flashcard, generates
a pair of fortune files (text and indexes) on a specific folder.
"""

import argparse
import logging
import os
import re
import subprocess
import sys

CURRENT_SCRIPT_NAME = os.path.splitext(os.path.basename(__file__))[0]
LOG_FORMAT = "[%(asctime)s %(levelname)s: %(message)s"
logging.basicConfig(
    format=LOG_FORMAT,
    level=logging.INFO,
    handlers=[
        # logging.FileHandler(f"{CURRENT_SCRIPT_NAME}.log"),
        logging.StreamHandler(sys.stdout),
    ],
)

FORTUNES_OUTPUT_DIR = '/tmp/fortunes'


def slugify(string: str):
    string = string.lower().strip()
    string = re.sub(r'[^\w\s-]', '', string)
    string = re.sub(r'[\s_-]+', '-', string)
    string = re.sub(r'^-+|-+$', '', string)
    return string


class FileNotFound(Exception):
    """Custom exception raised for file not found error

    Attributes:
        path -- full file path of the file that generated the error
        message -- explanation of the error
    """

    def __init__(self, file_path, message="File not found"):
        self.file_path = file_path
        self.message = message
        super().__init__(self.message)

    def __str__(self):
        return f"{self.file_path} -> {self.message}"


HEADER_SEPARATOR = "---"


def process_flashcard_file(input_file: str) -> str:
    if not os.path.exists(input_file):
        raise FileNotFound(file_path=input_file)

    with open(input_file) as flashcard:
        data = flashcard.readlines()

    header = data[:3]
    contents = data[5:]

    title = slugify(header[0])

    input_file_name = os.path.splitext(os.path.basename(input_file))[0]

    fortune_items = process_contents(contents)

    if not os.path.exists(FORTUNES_OUTPUT_DIR):
        os.makedirs(FORTUNES_OUTPUT_DIR)

    fortune_file_name = (
        f'{FORTUNES_OUTPUT_DIR}/{title}_{input_file_name}'.replace('-', '')
    )
    with (open(fortune_file_name, 'w')) as output_file:
        for index, item in enumerate(fortune_items, start=1):
            line = '\n'.join(item)
            fortune_separator = '%\n' if index != len(fortune_items) else ''
            output_file.write(f'{line}\n{fortune_separator}')

    return fortune_file_name


def process_contents(contents):
    fortune_items = []
    current_fortune = []
    for line_number, line in enumerate(contents):
        line = line.replace("\n", "")

        if line.strip() == "":
            continue

        if line.startswith('-'):
            if current_fortune:
                fortune_items.append(current_fortune)
                current_fortune = []
        current_fortune.append(line)

    return fortune_items


def run_shell_command(cmd: str):
    proc = subprocess.Popen(
        cmd,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        shell=True,
        universal_newlines=True,
    )
    std_out, std_err = proc.communicate()
    return proc.returncode, std_out, std_err


def generate_final_fortune_file(fortune_file_name: str):
    dat_file_name = f'{fortune_file_name}.dat'
    command = f'strfile -c % {fortune_file_name} {dat_file_name}'
    return_code, stdout, stderr = run_shell_command(command)
    if stderr:
        print(stderr)
    return return_code


def run(parsed_args: argparse.Namespace):
    logging.info(f"flashcard_file_path: {parsed_args.flashcard_file_path}")
    input_file = parsed_args.flashcard_file_path
    fortune_file_name = process_flashcard_file(input_file)
    generate_final_fortune_file(fortune_file_name)
    logging.info(f'Fortune file generated at: {fortune_file_name}')
    logging.info('To test, run: ')
    logging.info(f'    fortune -c {FORTUNES_OUTPUT_DIR}')


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "flashcard_file_path", type=str, help="path to flashcard file path"
    )
    try:
        run(parser.parse_args())
        sys.exit(0)
    except Exception as e:
        print(f"An exception occurred: {e.message}")
        sys.exit(1)
