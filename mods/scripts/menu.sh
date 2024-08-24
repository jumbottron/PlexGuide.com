#!/bin/bash

# Configuration file path
CONFIG_FILE="/pg/config/config.cfg"

# ANSI color codes
RED="\033[0;31m"
NC="\033[0m" # No color

# Clear the screen at the start
clear

# Function to source the configuration file
load_config() {
    if [[ -f "$CONFIG_FILE" ]]; then
        source "$CONFIG_FILE"
    else
        echo "VERSION=\"PG Alpha\"" > "$CONFIG_FILE"
        source "$CONFIG_FILE"
    fi
}

# Function for Apps Management
apps_management() {
    bash /pg/scripts/apps_starter_menu.sh
}

# Function to reinstall PlexGuide
reinstall_plexguide() {
    # Check if the config file exists
    if [[ -f "$CONFIG_FILE" ]]; then
        # Use sed to replace the value of VERSION with "PG Alpha"
        sed -i 's/^VERSION=.*/VERSION="PG Alpha"/' "$CONFIG_FILE"
        echo "VERSION has been set to PG Alpha in $CONFIG_FILE"
    else
        echo "Config file $CONFIG_FILE not found."
    fi

    # Execute the pgalpha command
    pgalpha
    exit 0
}

# Function to exit the script
menu_exit() {
    bash /pg/scripts/menu_exit.sh
    exit 0  # Ensure the script exits after executing the menu_exit.sh
}

# Function for HardDisk Management
harddisk_management() {
    bash /pg/scripts/drivemenu.sh
}

# Function for CloudFlare Tunnel Management
cloudflare_tunnel() {
    bash /pg/scripts/cf_tunnel.sh
}

# Function for Options Menu
options_menu() {
    bash /pg/scripts/options.sh
}

# Main menu loop
main_menu() {
    while true; do
        clear
        echo -e "${RED}Welcome to PlexGuide: $VERSION${NC}"
        echo ""  # Blank line for separation
        echo "A) Apps Management"
        echo "H) HardDisk Management"
        echo "C) CloudFlare Tunnel (Domains)"
        echo "O) Options"
        echo "R) Reinstall PlexGuide"
        echo "Z) Exit"
        echo ""  # Space between options and input prompt

        read -p "Enter your choice: " choice

        case ${choice,,} in
            a) apps_management ;;
            h) harddisk_management ;;
            c) cloudflare_tunnel ;;
            r) reinstall_plexguide ;;
            o) options_menu ;;
            z) menu_exit ;;  # Call the updated menu_exit function
            *)
                clear
                ;;
        esac
    done
}

# Run the script
load_config
main_menu
