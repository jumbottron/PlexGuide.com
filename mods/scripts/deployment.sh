#!/bin/bash

# ANSI color codes for green, red, blue, and orange
GREEN="\033[0;32m"
RED="\033[0;31m"
BLUE="\033[0;34m"
ORANGE="\033[0;33m"
NC="\033[0m" # No color

# Source the apps_interface function from the external script
source /pg/scripts/apps_interface

# Clear the screen at the start
clear

# Function to create the /pg/apps directory if it doesn't exist
create_apps_directory() {
    if [[ ! -d "/pg/apps" ]]; then
        mkdir -p /pg/apps
    fi
}

# Function to list all available apps in /pg/apps, excluding those already running in Docker
list_available_apps() {
    local all_apps=$(ls -1 /pg/apps | sort)
    local running_apps=$(docker ps --format '{{.Names}}' | sort)
    
    local available_apps=()
    for app in $all_apps; do
        if ! echo "$running_apps" | grep -i -w "$app" >/dev/null; then
            available_apps+=("$app")
        fi
    done

    if [[ ${#available_apps[@]} -eq 0 ]]; then
        echo -e "${ORANGE}No More Apps To Deploy${NC}"
    else
        echo "${available_apps[@]}"
    fi
}

# Function to deploy the selected app
deploy_app() {
    local app_name=$1
    local app_path="/pg/apps/$app_name"

    # Call the apps_interface function
    apps_interface "$app_name"
}

# Call the main menu function
main_menu
