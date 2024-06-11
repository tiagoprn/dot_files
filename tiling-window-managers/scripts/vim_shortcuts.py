#!/usr/bin/env python3
import argparse
import glob
import logging
import os
import subprocess
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
FILES_TO_PARSE = []
VIM_FLAVOR = ""


def get_shortcuts():
    shortcuts_list = []
    PREFIX = "/storage/src/dot_files"

    if VIM_FLAVOR == "vim":
        FILES_TO_PARSE = [f"{PREFIX}/.vimrc"]
    elif VIM_FLAVOR == "neovim":
        FILES_TO_PARSE = [
            # f'{PREFIX}/nvim/init.vim',
            f"{PREFIX}/nvim/abbreviations.vim",
            f"{PREFIX}/nvim/commands.vim",
            f"{PREFIX}/nvim/commands-tiagoprn-functions.vim",
            f"{PREFIX}/nvim/mappings-core.vim",
            f"{PREFIX}/nvim/mappings-commands.vim",
            f"{PREFIX}/nvim/mappings-functions.vim",
            f"{PREFIX}/nvim/mappings-plugins.vim",
            f"{PREFIX}/nvim/mappings-tiagoprn-functions.vim",
            f"{PREFIX}/nvim/cheatsheet-core.vim",
            f"{PREFIX}/nvim/cheatsheet-plugins.vim",
            f"{PREFIX}/nvim/conf-plugins/marvim.vim",
        ]

    for filename in FILES_TO_PARSE:
        print(f"parsing file: {filename}")
        with open(filename, "r") as input_file:
            lines = input_file.readlines()
        for line in lines:
            if line.replace("\n", "") and ('| "' in line):
                shortcut, description = line.split('| "')
                if shortcut and description:
                    _shortcut = (
                        shortcut[1:].strip()
                        if shortcut.startswith('"')
                        else shortcut.strip()
                    )
                    shortcuts_list.append(
                        f"{description.strip()} => {_shortcut}"
                    )
    return sorted(shortcuts_list)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()

    parser.add_argument(
        "-f",
        "--flavor",
        type=str,
        choices=["vim", "neovim"],
        help="vim flavor: vim / neovim",
    )
    args = parser.parse_args()
    VIM_FLAVOR = args.flavor
    if VIM_FLAVOR == "vim":
        print("(traditional) vim.")
    elif VIM_FLAVOR == "neovim":
        print("neovim detected.")

    shortcuts_list = get_shortcuts()

    rofi_client = Rofi()
    selected, keyboard_key = rofi_client.select(
        f"Filter a {VIM_FLAVOR} shortcut",
        shortcuts_list,
        fullscreen=True,
        other_args=["--no-case-sensitive"],
    )
    logging.info(f"keyboard_key pressed={keyboard_key}")

    if keyboard_key == -1:
        rofi_client.status("Cancelled, nothing to be done.")
        sys.exit(0)
    else:
        selected_text = shortcuts_list[selected]
        logging.info(f"Selected text is: {selected_text}")
        vim_command = selected_text.split("=>")[1].strip()

        try:
            if vim_command.index(":") >= 0:
                position = vim_command.index(":")
                vim_command = vim_command[position + 1 :]
                try:
                    if vim_command.index("<") >= 0:
                        position = vim_command.index("<")
                        vim_command = vim_command[:position]
                except:
                    pass
        except:
            pass

        cmd = 'echo "' + vim_command + "\" | tr -d '\\n'"
        cmd = cmd + " | wl-copy"
        subprocess.check_call(cmd, shell=True)
        logging.info(f"copied to clipboard >>> {cmd}")
