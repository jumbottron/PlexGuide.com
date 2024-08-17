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
        chmod -R +x "$dir"
    done
}

# Function to download and place files into /pg/stage/
download_repository() {
    echo "Preparing /pg/stage/ directory..."

    # Ensure /pg/stage/ is completely empty, including hidden files
    if [[ -d "/pg/stage/" ]]; then
        rm -rf /pg/stage/*
        rm -rf /pg/stage/.* 2>/dev/null || true
        echo "Cleared /pg/stage/ directory."
    fi

    # Download the repository
    echo "Downloading PlexGuide repository..."
    git clone https://github.com/plexguide/PlexGuide.com.git /pg/stage/

    # Verify download success
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

    # Check if the source directory exists
    if [[ -d "/pg/stage/mods/scripts" ]]; then
        mv /pg/stage/mods/scripts/* /pg/scripts/
        
        # Verify move success
        if [[ $? -eq 0 ]]; then
            echo "Scripts successfully moved to /pg/scripts/."
        else
            echo "Failed to move scripts. Please check the file paths and permissions."
            exit 1
        fi
    else
        echo "Source directory /pg/stage/mods/scripts does not exist. No files to move."
        bash /pg/scripts/basics.sh
        exit 1
    fi
}

# Function to move apps from /pg/stage/mods/apps to /pg/apps/
move_apps() {
    echo "Clearing the /pg/apps/ directory..."
    
    # Clear the /pg/apps/ directory, including hidden files
    if [[ -d "/pg/apps/" ]]; then
        rm -rf /pg/apps/*
        rm -rf /pg/apps/.* 2>/dev/null || true
        echo "Cleared /pg/apps/ directory."
    fi

    echo "Moving apps from /pg/stage/mods/apps to /pg/apps/..."

    # Check if the source directory exists
    if [[ -d "/pg/stage/mods/apps" ]]; then
        mv /pg/stage/mods/apps/* /pg/apps/
        
        # Verify move success
        if [[ $? -eq 0 ]]; then
            echo "Apps successfully moved to /pg/apps/."
        else
            echo "Failed to move apps. Please check the file paths and permissions."
            exit 1
        fi
    else
        echo "Source directory /pg/stage/mods/apps does not exist. No files to move."
        bash /pg/scripts/basics.sh
        exit 1
    fi
}

# Function to check and install Docker if not installed
check_and_install_docker() {
    if ! command -v docker &> /dev/null; then
        echo -e "\e[38;5;196mD\e[38;5;202mO\e[38;5;214mC\e[38;5;226mK\e[38;5;118mE\e[38;5;51mR \e[38;5;201mI\e[38;5;141mS \e[38;5;93mI\e[38;5;87mN\e[38;5;129mS\e[38;5;166mT\e[38;5;208mA\e[38;5;226mL\e[38;5;190mL\e[38;5;82mI\e[38;5;40mN\e[38;5;32mG\e[0m"
        sleep 2
        bash /pg/scripts/docker.sh
    fi
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
            check_and_install_docker
            create_directories
            download_repository
            move_scripts
            move_apps
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
    check_and_install_docker
    create_directories
    download_repository
    move_scripts
    move_apps
fi

# Continue with the installation process
# Add the necessary commands below to complete the installation
