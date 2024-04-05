#!/bin/bash

archive_directory() {
    # Clear the terminal
    clear

    # Sleep for 1 second
    sleep 1

    # Define the path to the archive folder in the home directory
    archive_folder="$HOME/archive"

    # Define the path to the archive log file
    archive_log_file="$archive_folder/archive.log"

    # Check if the archive folder exists, create it if it doesn't
    if [ ! -d "$archive_folder" ]; then
        echo "Creating archive folder in $HOME..."
        mkdir "$archive_folder"
        echo "archive folder created."

        # Create the archive log file
        touch "$archive_log_file"
        echo "archive.log file created."
    fi

    # Check if archive.log file exists, recreate it if deleted
    if [ ! -f "$archive_log_file" ]; then
        echo "archive.log file not found. Recreating..."
        touch "$archive_log_file"
        echo "archive.log file recreated."
    fi

    # Check if package.json exists in the current directory
    if [ -f "package.json" ]; then
        echo "package.json file exists in the current directory."

        # Get the current directory name
        current_dir=$(basename "$(pwd)")

        # Store the current directory path
        current_dir_path=$(pwd)

        # Get the size of the current directory (excluding node_modules)
        current_dir_size=$(du -sh . | cut -f1)

        # Check if node_modules directory exists in the current directory
        if [ -d "node_modules" ]; then
            echo "node_modules directory exists in the current directory. Deleting it..."
            rm -rf "node_modules"
            echo "node_modules directory deleted."
        else
            echo "node_modules directory does not exist in the current directory."
        fi

        # Create a zip file of the current directory (excluding node_modules)
        zip_file="$current_dir.zip"
        zip -r "$zip_file" . -x "node_modules/*"

        # Get the size of the zip file
        zip_size=$(du -h "$zip_file" | awk '{print $1}')

        # Log information about the zip file created in archive.log
        echo "Zip file: $zip_file | Current directory path: $current_dir_path | Current directory size: $current_dir_size | Zip file size: $zip_size" >> "$archive_log_file"

        # Move the zip file to the archive folder
        mv "$zip_file" "$archive_folder/"

        echo "Zip file created and moved to the archive folder."

        # Move one directory back directly in the current shell session
        cd ..
        echo "Moved back to the parent directory."

        # Delete the present directory
        echo "Deleting the present directory..."
        rm -rf "$current_dir"
        echo "Present directory deleted."

    else
        echo "package.json file does not exist in the current directory."
    fi
}

# Call the function
archive_directory
