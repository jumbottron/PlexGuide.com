#!/bin/bash

# ANSI color codes for green, red, and blue
GREEN="\033[0;32m"
RED="\033[0;31m"
BLUE="\033[0;34m"
NC="\033[0m" # No color

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

    echo "${available_apps[@]}"
}

# Function to deploy the selected app
deploy_app() {
    local app_name=$1
    local app_path="/pg/apps/$app_name"

    if [[ -f "$app_path" ]]; then
        echo "Deploying $app_name ..."
        bash "$app_path"

        # Notify the user that the app has been deployed and display the app name in blue
        echo -e "${BLUE}$app_name has been deployed.${NC}"
        read -p "Press Enter to continue..."
    else
        echo "Error: The app script for $app_name does not exist or is not executable."
        read -p "Press Enter to continue..."
    fi
}

# Main menu function
main_menu() {
    while true; do
        clear

        create_apps_directory

        APP_LIST=$(list_available_apps)

        echo -e "${BLUE}PG: App Deployment - Available Apps${NC}"
        echo ""  # Blank line for separation
        echo -e "${GREEN}Available Apps:${NC} ${APP_LIST[*]}"
        echo ""  # Blank line for separation

        read -p "$(echo -e "Type [${GREEN}App${NC}] to Deploy or [${RED}Exit${NC}]: ")" app_choice

        app_choice=$(echo "$app_choice" | tr '[:upper:]' '[:lower:]')

        if [[ "$app_choice" == "exit" ]]; then
            exit 0
        fi

        # Check if the app_choice matches any of the available apps exactly
        if [[ " ${APP_LIST[@]} " =~ " ${app_choice} " ]]; then
            deploy_app "$app_choice"
        else
            echo "Invalid choice. Please try again."
            read -p "Press Enter to continue..."
        fi
    done
}

# Call the main menu function
main_menu
