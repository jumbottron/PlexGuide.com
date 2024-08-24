#!/bin/bash

# Path to the configuration file
CONFIG_FILE="/pg/config/config.cfg"

# ANSI color codes
RED="\033[0;31m"
GREEN="\033[0;32m"
NC="\033[0m" # No color

# Function to create directories with the correct permissions
create_directories() {
    echo "Creating necessary directories..."
    directories=(
        "/pg/config"
        "/pg/scripts"
        "/pg/apps"
        "/pg/stage"
    )

    for dir in "${directories[@]}"; do
        if [[ ! -d "$dir" ]]; then
            mkdir -p "$dir"
            echo "Created $dir"
        else
            echo "$dir already exists"
        fi
        chown -R 1000:1000 "$dir"
        chmod -R +x "$dir"
    done
}

# Function to download and place files into /pg/stage/
download_repository() {
    echo "Preparing /pg/stage/ directory..."
    if [[ -d "/pg/stage/" ]]; then
        rm -rf /pg/stage/* /pg/stage/.* 2>/dev/null || true
        echo "Cleared /pg/stage/ directory."
    fi

    echo "Downloading PlexGuide repository..."
    git clone https://github.com/plexguide/PlexGuide.com.git /pg/stage/
    if [[ $? -eq 0 ]]; then
        echo "Repository successfully downloaded to /pg/stage/."
    else
        echo "Failed to download the repository. Please check your network connection."
        exit 1
    fi
}

# Function to move scripts from /pg/stage/mods/scripts to /pg/scripts/
move_scripts() {
    echo "Moving scripts from /pg/stage/mods/scripts to /pg/scripts/..."
    if [[ -d "/pg/stage/mods/scripts" ]]; then
        mv /pg/stage/mods/scripts/* /pg/scripts/
        if [[ $? -eq 0 ]]; then
            echo "Scripts successfully moved to /pg/scripts/."
        else
            echo "Failed to move scripts. Please check the file paths and permissions."
            exit 1
        fi
    else
        echo "Source directory /pg/stage/mods/scripts does not exist. No files to move."
        exit 1
    fi
}

# Function to move apps from /pg/stage/mods/apps to /pg/apps/
move_apps() {
    echo "Clearing the /pg/apps/ directory..."
    if [[ -d "/pg/apps/" ]]; then
        rm -rf /pg/apps/* /pg/apps/.* 2>/dev/null || true
        echo "Cleared /pg/apps/ directory."
    fi

    echo "Moving apps from /pg/stage/mods/apps to /pg/apps/..."
    if [[ -d "/pg/stage/mods/apps" ]]; then
        mv /pg/stage/mods/apps/* /pg/apps/
        if [[ $? -eq 0 ]]; then
            echo "Apps successfully moved to /pg/apps/."
        else
            echo "Failed to move apps. Please check the file paths and permissions."
            exit 1
        fi
    else
        echo "Source directory /pg/stage/mods/apps does not exist. No files to move."
        exit 1
    fi
}

# Function to check and install Docker if not installed
check_and_install_docker() {
    if ! command -v docker &> /dev/null; then
        echo "Docker is not installed. Installing..."
        chmod +x /pg/scripts/docker.sh
        bash /pg/scripts/docker.sh
    fi
}

# Main Reinstall Logic
if [[ -f "$CONFIG_FILE" ]]; then
    yes_code=$(printf "%04d" $((RANDOM % 10000)))
    no_code=$(printf "%04d" $((RANDOM % 10000)))

    while true; do
        clear
        echo "An existing PlexGuide installation has been detected."
        echo "Do you want to move forward with reinstallation?"
        echo ""
        echo -e "Type [${RED}${yes_code}${NC}] to proceed or [${GREEN}${no_code}${NC}] to cancel: "
        read -p "" response

        if [[ "$response" == "$yes_code" ]]; then
            echo "Reinstalling PlexGuide..."
            create_directories
            download_repository
            move_scripts
            move_apps
            check_and_install_docker
            exit 0  # Exit after reinstall to avoid returning control
        elif [[ "$response" == "$no_code" ]]; then
            echo "Installation aborted."
            exit 0  # Exit after cancellation to avoid returning control
        else
            clear
        fi
    done
else
    echo "No existing installation detected. Proceeding with a new installation..."
    create_directories
    download_repository
    move_scripts
    move_apps
    check_and_install_docker
    exit 0  # Exit after new installation
fi