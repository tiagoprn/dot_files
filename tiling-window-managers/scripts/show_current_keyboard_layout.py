import os
import subprocess
import sys

def get_current_keyboard_layout():
    main_command = subprocess.Popen(('setxkbmap', '-query'), stdout=subprocess.PIPE)
    pipe_command = subprocess.check_output(('grep', 'layout'), stdin=main_command.stdout)
    main_command.wait()

    final_output = pipe_command.decode('utf-8')
    current_layout = final_output.replace('\n', '').split()[1]
    return current_layout


if __name__ == "__main__":
    # Below is equivalent to: `setxkbmap -query | grep layout`
    current_layout = get_current_keyboard_layout()
    print(current_layout)

