#!/usr/bin/env python3

from sys import stdout

SXHKDRC_PATH = '/storage/src/dot_files/tiling-window-managers/sxhkd/sxhkdrc'

with open(SXHKDRC_PATH) as config_file:
    print_next_line = False
    new_entry = ''
    entry_prefix = ''
    for line in config_file:
        line = line.replace('\n', '')
        is_comment_line = line.startswith('#') and line.endswith(':')

        is_wm_specific_session = line.startswith('### ')
        if is_wm_specific_session:
            # __import__('pdb').set_trace()
            entry_prefix = f'({line[4:]}) '
            # print(entry_prefix)

        if is_comment_line:
            print_next_line = True
            new_entry = f'{entry_prefix}{line[2:-1]}'.ljust(70)
        elif print_next_line:
            new_entry += f' {line}\n'
            stdout.write(new_entry)
            print_next_line = False


