#!/usr/bin/env python3
import os
from sys import stdout

HOME = os.getenv("HOME")
CONFIG_PATH = f"{HOME}/.gitconfig"

with open(CONFIG_PATH) as config_file:
    print_next_line = False
    new_entry = ""
    entry_prefix = ""
    for line in config_file:
        line = line.replace("\n", "")

        is_finished = line.startswith("[status]")
        if is_finished:
            break

        is_comment_line = line.startswith("  #") and line.endswith(":")

        if is_comment_line:
            print_next_line = True
            new_entry = f"{line[2:-1]}".ljust(100)
        elif print_next_line:
            new_entry += f"{line.split('=')[0].strip()}\n"
            stdout.write(new_entry[2:])
            print_next_line = False
