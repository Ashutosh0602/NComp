#!/bin/bash

# Function to search for package.json files within directories
search_package_json() {
    dir="$1"
    # Use find command to search for package.json files within the directory
    find "$dir" \( -type d -name 'node_modules' -prune \) -o \( -type f -name 'package.json' -exec dirname {} \; \) 2>/dev/null
}

# search_package_json() {
#     local dir="$1"

#     # Iterate over each file and directory in the specified directory
#     for item in "$dir"/*; do
#         # Check if the item is a directory
#         if [ -d "$item" ]; then
#             # If the directory is named 'node_modules', skip it
#             if [ "$(basename "$item")" = "node_modules" ]; then
#                 continue
#             fi
#             # Recursively search the directory
#             search_package_json "$item"
#         elif [ "$(basename "$item")" = "package.json" ]; then
#             # If the item is a package.json file, print its parent directory path
#             echo "$(dirname "$item")"
#         fi
#     done
# }




# Main script
main() {
    # List all directories in the home directory and iterate over them
    for dir in ~//*/; do
        # Check if the directory exists and is accessible
        if [ -d "$dir" ]; then
            # Call the function to search for package.json files within the directory
            search_package_json "$dir"
        else
            # Print an error message if the directory is inaccessible
            echo "Error: Directory $dir is inaccessible"
        fi
    done | uniq
}

# Call the main function
main
