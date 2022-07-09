import os
import subprocess
import sys

US_KEYS = 'setxkbmap us -variant intl'
BR_KEYS = 'setxkbmap -model abnt2 -layout br'


def change_keyboard_layout(to):
    if to == 'us':
        subprocess.run(US_KEYS.split())
    elif to == 'br':
        subprocess.run(BR_KEYS.split())
    else:
        raise Exception('Undefined layout "{}"'.format(to))


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
    print('Keyboard layout was {}'.format(current_layout))

    change_to = ''
    if current_layout == 'us':
        change_to = 'br'
    elif current_layout == 'br':
        change_to = 'us'
    else:
        raise Exception('Undefined current layout.')

    change_keyboard_layout(change_to)

    print('Keyboard layout is now {}'.format(change_to))

