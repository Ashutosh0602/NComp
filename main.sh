#!/bin/bash

# Function to archive a directory
archive_directory() {
    # source /Users/ashutoshrai/shell/projects/find_node/ascii.sh

    # Clear the terminal
    clear

    # Define the path to the archive folder in the home directory
    archive_folder="$HOME/archive"

    # Define the path to the archive log file
    archive_log_file="$archive_folder/archive.log"

    # Check if the archive folder exists, create it if it doesn't
    if [ ! -d "$archive_folder" ]; then
        echo -e "\033[32mCreating archive folder in $HOME...\033[0m"
        mkdir "$archive_folder"
        echo -e "\033[32marchive folder created.\033[0m"

        # Create the archive log file
        touch "$archive_log_file"
        echo -e "\033[32marchive.log file created.\033[0m"
    fi

    # Check if archive.log file exists, recreate it if deleted
    if [ ! -f "$archive_log_file" ]; then
        echo -e "\033[33marchive.log file not found. Recreating...\033[0m"
        touch "$archive_log_file"
        echo -e "\033[33marchive.log file recreated.\033[0m"
    fi

    # Check if package.json exists in the current directory
    if [ -f "package.json" ]; then
        echo -e "\033[34mpackage.json file exists in the current directory.\033[0m"

        # Get the current directory name
        current_dir=$(basename "$(pwd)")

        # Store the current directory path
        current_dir_path=$(pwd)

        # Get the size of the current directory (excluding node_modules)
        current_dir_size=$(du -sh . | cut -f1)

        # Check if node_modules directory exists in the current directory
        if [ -d "node_modules" ]; then
            echo -e "\033[33mnode_modules directory exists in the current directory. Deleting it...\033[0m"
            rm -rf "node_modules"
            echo -e "\033[33mnode_modules directory deleted.\033[0m"
        else
            echo -e "\033[33mnode_modules directory does not exist in the current directory.\033[0m"
        fi

        # Create a zip file of the current directory (excluding node_modules)
        zip_file="$current_dir.zip"

        # Show loading bar animation
        echo -n "Creating zip file: ["
        for ((i = 0; i < 10; i++)); do
            sleep 0.1
            echo -n "▇"
        done
        echo "]"

        zip -r "$zip_file" . -x "node_modules/*"

        # Get the size of the zip file
        zip_size=$(du -h "$zip_file" | awk '{print $1}')

        # Log information about the zip file created in archive.log
        echo -e "\033[32mZip file: $zip_file | Current directory path: $current_dir_path | Current directory size: $current_dir_size | Zip file size: $zip_size\033[0m" >> "$archive_log_file"

        # Move the zip file to the archive folder
        mv "$zip_file" "$archive_folder/"

        echo -e "\033[32mZip file created and moved to the archive folder.\033[0m"

        # Move one directory back directly in the current shell session
        cd ..
        echo -e "\033[34mMoved back to the parent directory.\033[0m"

        # Delete the present directory
        echo -e "\033[33mDeleting the present directory...\033[0m"
        rm -rf "$current_dir"
        echo -e "\033[33mPresent directory deleted.\033[0m"

    else
        echo -e "\033[31mpackage.json file does not exist in the current directory.\033[0m"
    fi
}


# Function to list all zip files in the archive folder
list_zip_files() {
    # source /Users/ashutoshrai/shell/projects/find_node/ascii.sh
    
    echo -e "\033[36mListing all zip files in the archive folder:\033[0m"
    ls -l "$HOME/archive"/*.zip | awk '{print $NF}' | xargs -n 1 basename
}

#!/bin/bash

# Function to update the archive log file
update_archive_log() {
    # source /Users/ashutoshrai/shell/projects/find_node/ascii.sh

    if [ -z "$2" ]; then
        echo -e "\033[31mError: Missing filename argument. Usage: $0 -u \033[31;47m<filename>\033[0m"
        exit 1
    fi

    filename="$2"

    # Define the path to the archive folder in the home directory
    archive_folder="$HOME/archive"

    # Define the path to the archive log file
    archive_log_file="$archive_folder/archive.log"

    # Check if the file exists in the archive folder
    if [ -f "$archive_folder/$filename" ]; then
        echo -e "\033[32mFile \033[33;47m'$filename'\033[0m exists in the archive folder.\033[0m"
        
        # Check if archive.log file exists
        if [ ! -f "$archive_log_file" ]; then
            echo -e "\033[31mError: archive.log file not found.\033[0m"
            exit 1
        fi

        # Search for the filename in the archive log and extract the current directory path
        current_dir_path=$(grep "$filename" "$archive_log_file" | awk -F '|' '{print $2}' | sed 's/Current directory path://' | head -n 1 | tr -d '[:space:]')

        if [ -z "$current_dir_path" ]; then
            echo -e "\033[31mError: Current directory path not found for file \033[33;47m'$filename'\033[0m in archive.log.\033[0m"
        else
            echo -e "\033[32mCurrent directory path for file \033[33;47m'$filename'\033[0m: \033[31;47m$current_dir_path\033[0m"

            # Show loading animation while unzipping the file
            echo -n "Unzipping the file: "
            for ((i = 0; i < 10; i++)); do
                echo -n "."
                sleep 0.1
            done
            echo ""

            # Unzip the file
            unzip -q "$archive_folder/$filename" -d "$current_dir_path"

            if [ $? -eq 0 ]; then
                echo -e "\033[32mUnzipped folder moved to its original directory: \033[31;47m$current_dir_path\033[0m"

                # Change directory to the unzipped folder
                cd "$current_dir_path"
                
                # Check if package.json exists
                if [ -f "package.json" ]; then
                    # Install node modules
                    npm install
                else
                    echo -e "\033[31mError: package.json not found in the unzipped folder.\033[0m"
                fi

                # Move back to the original directory
                cd "$OLDPWD"

                # Remove the file entry from the archive log
                sed -i -e "/$(sed 's/[\/&]/\\&/g' <<< "$filename")/d" "$archive_log_file"
                if [ $? -eq 0 ]; then
                    echo -e "\033[32mEntry for file \033[33;47m'$filename'\033[0m deleted from the archive log.\033[0m"

                    # Remove the zip folder from the archive folder
                    rm "$archive_folder/$filename"
                    if [ $? -eq 0 ]; then
                        echo -e "\033[32mZip folder \033[33;47m'$filename'\033[0m deleted from the archive folder.\033[0m"
                    else
                        echo -e "\033[31mError: Failed to delete zip folder \033[33;47m'$filename'\033[0m from the archive folder.\033[0m"
                    fi
                else
                    echo -e "\033[31mError: Failed to delete entry for file \033[33;47m'$filename'\033[0m from the archive log.\033[0m"
                fi
            else
                echo -e "\033[31mError: Failed to unzip the file \033[33;47m'$filename'\033[0m to the directory \033[31;47m'$current_dir_path'\033[0m"
            fi
        fi
    else
        echo -e "\033[31mFile \033[33;47m'$filename'\033[0m does not exist in the archive folder.\033[0m"
    fi
}

# Function to execute any command to initiate a Node project
initiate_node_project() {

    # Ensure cron.log exists in the Archive folder
    cron_log="$HOME/archive/cron.log"
    if [ ! -f "$cron_log" ]; then
        touch "$cron_log"
        echo -e "\033[32mCreated cron.log in the Archive folder.\033[0m"
    fi

    # Get the current folder name and path before any changes
    current_folder=$(basename "$(pwd)")
    current_path="$(pwd)"
    
    # Capture the initial state of the current directory
    initial_state=$(ls -1)

    read -p $'\033[36mEnter the Node project initiation command:\033[0m ' command
    echo -e "\033[32mExecuting command: $command...\033[0m"
    eval "$command"

    final_state=$(ls -1)
    new_files=$(diff <(echo "$initial_state") <(echo "$final_state") | grep ">" | awk '{print $2}')

     if [[ -n "$new_files" ]]; then
        echo -e "\033[34mNew files/folders created:\033[0m"
        echo "$new_files" | while IFS= read -r item; do
            if [ -f "$item" ]; then  
                if [ "$item" == "package.json" ]; then  
                    echo -e "\033[32m'$item' created in $current_folder ($current_path).\033[0m"
                    echo "$current_folder : $current_path" >> "$cron_log"  
                else
                    echo "- $item"
                fi
            elif [ -d "$item" ]; then  
                if [ -f "$item/package.json" ]; then  
                    folder_path="$(pwd)/$item"
                    echo "- $item : ($folder_path)"
                    echo "$item : $folder_path" >> "$cron_log"  
                else
                    echo "- $item (Folder)"
                fi
            else
                echo "- $item (Unknown type)"
            fi
        done
    else
        echo -e "\033[31mNo new files or folders created.\033[0m"
    fi
}

# Check the argument passed
case "$1" in
    -c)
        # Call the function archive_directory
        archive_directory
        ;;
    -l)
        # Call the function list_zip_files
        list_zip_files
        ;;
    -u)
        # Call the function update_archive_log with the second argument
        update_archive_log "$@"
        ;;
    -i)
        # Call the function to execute any command to initiate a Node project
        initiate_node_project
        ;;
    *)
        echo "Error: Irrelevant argument. Usage: ncomp -c or ncomp -l or ncomp -u <filename> or ncomp -i"
        exit 1
        ;;
esac