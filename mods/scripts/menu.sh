#!/bin/bash

# Configuration file path
CONFIG_FILE="/pg/config/config.cfg"

# ANSI color codes for red and no color
RED="\033[0;31m"
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

# Function for the main menu
main_menu() {
  while true; do
    clear
    echo -e "${RED}Welcome to PlexGuide: $VERSION${NC}"
    echo ""  # Blank line for separation
    # Display the main menu options
    echo "A) Apps Management"
    echo "C) CloudFlare Tunnel (Domains)"
    echo "R) Reinstall PlexGuide"
    echo "Z) Exit"
    echo ""  # Space between options and input prompt

    # Prompt the user for input
    read -p "Enter your choice [A/C/R/Z]: " choice

    case ${choice,,} in  # Convert input to lowercase for a/A, c/C, r/R, z/Z handling
      a)
        /pg/scripts/apps.sh
        ;;
      c)
        /pg/scripts/cf_tunnel.sh
        ;;
      r)
        clear
        local reinstall_code=$(printf "%04d" $((RANDOM % 10000)))  # Generate a 4-digit code
        while true; do
          read -p "$(echo -e "To reinstall PlexGuide, type [${RED}${reinstall_code}${NC}] to proceed or [${RED}no${NC}] to cancel: ")" input_code
          if [[ "$input_code" == "$reinstall_code" ]]; then
            clear
            echo "Downloading and executing the install script..."
            # Download the install.sh script
            curl -o /tmp/install.sh https://raw.githubusercontent.com/plexguide/PlexGuide.com/v11/mods/install/install.sh
            
            # Make the script executable
            chmod +x /tmp/install.sh

            # Execute the script
            /tmp/install.sh

            # Cleanup
            rm -f /tmp/install.sh

            # Exit and reload using the plexguide command
            bash /pg/scripts/basics.sh
            echo "Reloading PlexGuide..."
            sleep 2
            exec plexguide
            break
          elif [[ "${input_code,,}" == "no" ]]; then
            echo "Operation cancelled."
            break
          else
            echo -e "${RED}Invalid response.${NC} Please type [${RED}${reinstall_code}${NC}] or [${RED}no${NC}]."
          fi
        done
        ;;
      z)
        clear
        echo "Visit https://plexguide.com"
        echo -e "To Start Again - Type: [${RED}pg${NC}] or [${RED}plexguide${NC}]"
        echo ""  # Space before exiting
        exit 0
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
