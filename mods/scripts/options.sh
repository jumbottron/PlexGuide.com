#!/bin/bash

# Configuration file path
CONFIG_FILE="/pg/config/config.cfg"

# ANSI color codes
RED="\033[0;31m"
BLUE="\033[0;34m"
NC="\033[0m" # No color

# Clear the screen at the start
clear

# Ensure /pg/scripts/basics.sh is executable, then run it in the background
chmod +x /pg/scripts/basics.sh
/pg/scripts/basics.sh &

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

# Function for Graphics Cards option
graphics_cards() {
    clear
    echo -e "${BLUE}Graphics Cards Management${NC}"
    echo ""  # Space for separation
    echo "This is where you'd manage your Graphics Cards."
    echo "Add your GPU-related commands here."
    read -p "Press Enter to return to the main menu..."
}

# Function for SSH Management option
ssh_management() {
    clear
    echo -e "${BLUE}SSH Management${NC}"
    echo ""  # Space for separation
    echo "This is where you'd manage your SSH settings."
    echo "Add your SSH-related commands here."
    read -p "Press Enter to return to the main menu..."
}

# Function to exit the script
exit_script() {
    clear
    echo "Visit https://plexguide.com"
    echo -e "To Start Again - Type: [${RED}pg${NC}] or [${RED}plexguide${NC}]"
    echo ""  # Space before exiting
    exit 0
}

# Function for the main menu
main_menu() {
  while true; do
    clear
    echo -e "${BLUE}PlexGuide Options Interface${NC}"
    echo ""  # Blank line for separation
    # Display the main menu options
    echo "G) Graphics Cards"
    echo "S) SSH Management"
    echo "Z) Exit"
    echo ""  # Space between options and input prompt

    # Prompt the user for input
    read -p "Enter your choice [G/S/Z]: " choice

    case ${choice,,} in  # Convert input to lowercase for g/G, s/S, z/Z handling
      g)
        graphics_cards
        ;;
      s)
        ssh_management
        ;;
      z)
        exit_script
        ;;
      *)
        echo "Invalid option, please try again."
        read -p "Press Enter to continue..."
        ;;
    esac

  done
}

# Call the main menu function
main_menu

