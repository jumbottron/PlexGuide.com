#!/bin/bash

# ANSI color codes for green, red, and blue
GREEN="\033[0;32m"
RED="\033[0;31m"
BLUE="\033[0;34m"
NC="\033[0m" # No color

# Clear the screen at the start
clear

# Create the /pg/apps directory if it doesn't exist
if [[ ! -d "/pg/apps" ]]; then
    mkdir -p /pg/apps
fi

# List the files in /pg/apps alphabetically, separated by a space
APP_LIST=$(ls -1 /pg/apps | sort | tr '\n' ' ')

# Main menu
main_menu() {
    while true; do
        clear
        echo -e "${BLUE}PG: App Deployment - Available Apps${NC}"
        echo ""  # Blank line for separation

        # Display the list of apps on the same line
        echo -e "${GREEN}Available Apps:${NC} $APP_LIST"
        echo ""  # Blank line for separation

        # Prompt the user to enter an app name or exit
        read -p "$(echo -e "Type [${GREEN}App${NC}] to Deploy or [${RED}Exit${NC}]: ")" app_choice

        # Convert the user input to lowercase for case-insensitive matching
        app_choice=$(echo "$app_choice" | tr '[:upper:]' '[:lower:]')

        # Check if the user wants to exit
        if [[ "$app_choice" == "exit" ]]; then
            exit 0
        fi

        # Check if the app exists in the list (case-insensitive)
        if echo "$APP_LIST" | grep -i -w "$app_choice" >/dev/null; then
            echo "Deploying $app_choice..."
            # Add your deployment logic here
        else
            echo "Invalid choice. Please try again."
            read -p "Press Enter to continue..."
        fi
    done
}

# Call the main menu function
main_menu
