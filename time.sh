#!/bin/bash

# Get the modification timestamp of the most recently modified file
mod_timestamp=$(ls -lt | awk 'NR==2 {print $6, $7, strftime("%Y")}')

# Convert the modification timestamp to epoch time
mod_epoch=$(date -j -f "%b %d" "$mod_timestamp" +"%s")

# Get the current epoch time
current_epoch=$(date +"%s")

# Calculate the difference in seconds between the current time and the modification time
time_diff=$((current_epoch - mod_epoch))

# Convert the time difference from seconds to days
days_diff=$((time_diff / (60*60*24)))

echo "The most recently modified file was modified $days_diff days ago."


