#!/bin/bash

# Set the filename to banner.txt
filename="/Users/ashutoshrai/shell/projects/find_node/banner.txt"

# Check if the file exists
if [ ! -f "$filename" ]; then
    echo "File $filename does not exist."
    exit 1
fi

# Use the `file` command to determine the file type
file_type=$(file "$filename")

# Check if the file is ASCII text
if [[ $file_type == *"ASCII text"* ]]; then
    # Print ASCII text content with limited width
    cat "$filename" | fold -w 80
else
    echo "The file $filename does not contain ASCII text."
fi
