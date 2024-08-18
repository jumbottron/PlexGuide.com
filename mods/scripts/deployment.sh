#!/bin/bash

# ANSI color codes
GREEN="\033[0;32m"
RED="\033[0;31m"
BLUE="\033[0;34m"
ORANGE="\033[0;33m"
NC="\033[0m" # No color

# Source the apps_interface function
source /pg/scripts/apps_interface
source /pg/scripts/apps_default

# Ensure /pg/apps directory exists
[[ ! -d "/pg/apps" ]] && mkdir -p /pg/apps

# List all available apps in /pg/apps, excluding those already running in Docker
list_available_apps() {
    comm -23 <(ls -1 /pg/apps | sort) <(docker ps --format '{{.Names}}' | sort)
}

# Deploy the selected app
deploy_app() {
    apps_interface "$1"
}

# Destroy the selected app
destroy_app() {
    local app_container=$(docker ps --filter "name=$1" --format "{{.ID}}")
    if [[ -n "$app_container" ]]; then
        docker stop "$app_container" && docker rm "$app_container"
        echo -e "\n${RED}$1${NC} has been destroyed."
    else
        echo "Error: The app $1 is not running or does not exist."
    fi
    read -p "Press any key to continue..." -n 1 -s
}

# Main menu
main_menu() {
    while true; do
        clear
        echo -e "${BLUE}PG: App Deployment - Available Apps${NC}\n"

        local APP_LIST=$(list_available_apps)
        [[ -z "$APP_LIST" ]] && echo -e "${ORANGE}No More Apps To Deploy${NC}" || echo -e "${GREEN}Available Apps:${NC} $APP_LIST\n"

        read -p "$(echo -e "Type [${GREEN}App${NC}] to Deploy, [${RED}Destroy${NC}] to Remove, or [${RED}Exit${NC}]: ")" app_choice
        app_choice=$(echo "$app_choice" | tr '[:upper:]' '[:lower:]')

        case "$app_choice" in
            exit) exit 0 ;;
            destroy) read -p "Enter the name of the app to destroy: " destroy_choice; destroy_app "$destroy_choice" ;;
            *) [[ " $APP_LIST " =~ " $app_choice " ]] && deploy_app "$app_choice" || { echo "Invalid choice. Please try again."; read -p "Press Enter to continue..."; }
        esac
    done
}

# Run the main menu
main_menu
