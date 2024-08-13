#!/bin/bash

# Configuration file path
CONFIG_FILE="/pg/config/config.cfg"

# Clear the screen at the start
clear

# Function to source the configuration file
load_config() {
    if [[ -f "$CONFIG_FILE" ]]; then
        source "$CONFIG_FILE"
    else
        echo "VERSION=\"11.0 Beta\"" > "$CONFIG_FILE"
        source "$CONFIG_FILE"
    fi
}

# Load the configuration
load_config

# Function to check and apply executable permissions
check_and_fix_permissions() {
    for script in /pg/scripts/*; do
        if [[ ! -x "$script" ]]; then
            chmod +x /pg/scripts/* &
            break
        fi
    done
}

# Run the permission check in the background
check_and_fix_permissions &

# Function for the main menu
main_menu() {
  while true; do
    clear
    echo "Welcome to PlexGuide: $VERSION"
    echo ""  # Blank line for separation
    # Display the main menu options
    echo "Please select an option:"
    echo "1) CloudFlare Tunnel (Domains)"
    echo "2) Test A2"
    echo "3) Test B1"
    echo "4) Test B2"
    echo "5) Test C1"
    echo "6) Test C2"
    echo "7) Exit"
    echo ""  # Space between options and input prompt

    # Prompt the user for input
    read -p "Enter your choice [1-7]: " choice

    case $choice in
      1)
        /pg/scripts/cf_tunnel.sh
        ;;
      2)
        clear
        echo "Executed Test A2"
        ;;
      3)
        clear
        echo "Executed Test B1"
        ;;
      4)
        clear
        echo "Executed Test B2"
        ;;
      5)
        clear
        echo "Executed Test C1"
        ;;
      6)
        clear
        echo "Executed Test C2"
        ;;
      7)
        exit 0
        ;;
      *)
        echo "Invalid option, please try again."
        ;;
    esac

    # Prompt the user to press Enter to continue...
    read -p "Press Enter to continue..."
  done
}

# Call the main menu function
main_menu
