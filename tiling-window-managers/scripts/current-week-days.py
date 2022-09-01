#!/usr/bin/env python3

# Get all the days from the current week (from sunday to saturday.)

import datetime
import sys

theday = datetime.date.today()
weekday = theday.isoweekday()
# The start of the week
start = theday - datetime.timedelta(days=weekday)
dates = [start + datetime.timedelta(days=d) for d in range(7)]
for date in dates:
    date_as_str = date.strftime("%Y/%m/%d (%A)")
    sys.stdout.write(f"{date_as_str};")
