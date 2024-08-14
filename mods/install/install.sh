#!/bin/bash

# Path to the configuration file
CONFIG_FILE="/pg/config/config.cfg"

# Function to create directories with the correct permissions
create_directories() {
    echo "Creating necessary directories..."

    # Define directories to create
    directories=(
        "/pg/config"
        "/pg/scripts"
        "/pg/apps"
        "/pg/stage"
    )

    # Loop through the directories and create them with the correct permissions
    for dir in "${directories[@]}"; do
        if [[ ! -d "$dir" ]]; then
            mkdir -p "$dir"
            echo "Created $dir"
        else
            echo "$dir already exists"
        fi
        # Set ownership to user with UID and GID 1000
        chown -R 1000:1000 "$dir"
        # Set the directories as executable
        chmod -R 755 "$dir"
    done
}

# Check if the configuration file exists
if [[ -f "$CONFIG_FILE" ]]; then
    # Prompt the user for reinstallation
    echo "An existing PlexGuide installation has been detected."
    read -p "Do you want to reinstall PlexGuide? (Y/N): " response

    case "$response" in
        Y|y)
            echo "Reinstalling PlexGuide..."
            # Reinstallation process
            create_directories
            ;;
        N|n)
            echo "Installation aborted."
            exit 0
            ;;
        *)
            echo "Invalid input. Please run the script again and choose Y or N."
            exit 1
            ;;
    esac
else
    echo "No existing installation detected. Proceeding with a new installation..."
    # New installation process
    create_directories
fi

# Continue with the installation process
# Add the necessary commands below to complete the installation

