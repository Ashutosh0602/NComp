#!/bin/bash

# Define the path to the cron log file
cron_log="$HOME/archive/cron.log"

# Check if the cron log file exists
if [[ ! -f "$cron_log" ]]; then
    echo "Error: Cron log file does not exist at $cron_log"
    exit 1
fi

# Read each line from the log file
while IFS= read -r line; do
    # Skip empty lines or lines without a proper separator
    if [[ -z "$line" || "$line" != *" : "* ]]; then
        continue
    fi

    # Extract the directory path from each line
    directory_path=$(echo "$line" | awk -F ' : ' '{print $2}' | tr -d ' ')

    # Check if the extracted path is a valid directory
    if [[ -d "$directory_path" ]]; then
        # Get the last access time (atime) using stat
        atime=$(stat -c "%Y" "$directory_path" 2>/dev/null) # GNU-based systems
        if [[ -z "$atime" ]]; then
            atime=$(stat -f "%m" "$directory_path" 2>/dev/null) # BSD-based systems
        fi

        if [[ -z "$atime" ]]; then
            echo "Error: Could not retrieve access time for $directory_path"
        else
            current_time=$(date +%s)
            time_diff=$((current_time - atime))
            minutes=$((time_diff / 60))

            echo "Directory: $directory_path"
            echo "Minutes since last access: $minutes"

            if [[ $minutes -gt 43200 ]]; then
                echo "Running ncomp -c in $directory_path"
                cd "$directory_path" || continue
                ncomp -c
                cd - >/dev/null || exit
            fi
        fi
    else
        echo "Error: '$directory_path' is not a valid directory"
    fi
done < "$cron_log"