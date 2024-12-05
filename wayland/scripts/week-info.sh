#!/usr/bin/env bash

# Get the current week number
current_week=$(date +%V)

# Calculate the total number of weeks in the current year
# %G is the ISO year, used to handle edge cases where the year starts/ends with incomplete weeks
total_weeks=$(date -d "$(date +%G)-12-28" +%V)

# Output the formatted week information
echo "{\"text\": \"Week $current_week/$total_weeks\"}"
