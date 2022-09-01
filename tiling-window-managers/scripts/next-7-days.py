#!/usr/bin/env python3

# Get all the days from the current week (from sunday to saturday.)

import datetime
import sys

today = datetime.date.today()
# The start of the week
dates = [today + datetime.timedelta(days=d) for d in range(8)]
for date in dates:
    date_as_str = date.strftime("%Y/%m/%d (%A)")
    sys.stdout.write(f"{date_as_str};")
