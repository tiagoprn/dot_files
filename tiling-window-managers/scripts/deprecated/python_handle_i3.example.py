#!/usr/bin/python

"""
Example on how to interact with i3 using python.

Requires i3ipc:

$ sudo pip install i3ipc
"""

import i3ipc
import os

i3 = i3ipc.Connection()

i3.command('workspace next')

focused = i3.get_tree().find_focused()

wspce=int(focused.workspace().name[:1])

if wspce == 2:
   os.system("killall compton")
else:
   os.system("compton -b")

