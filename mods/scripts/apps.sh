#!/bin/bash

# Source the apps_interface function from the external script
source /pg/scripts/apps_interface

# Source the running and deployment functions directly instead of as separate scripts
source /pg/scripts/running.sh
source /pg/scripts/deployment.sh

# ANSI color codes for green, red, blue, and orange
GREEN="\033[0;32m"
RED="\033[0;31m"
BLUE="\033[0;34m"
ORANGE="\033[0;33m"
NC="\033[0m" # No color

# Terminal width and maximum character length per line
TERMINAL_WIDTH=98
MAX_LINE_LENGTH=91

# Function to count running Docker containers, excluding cf_tunnel
count_docker_apps() {
    docker ps --format '{{.Names}}' | grep -v 'cf_tunnel' | wc -l
}

# Function to generate the list of available apps
generate_app_list() {
    current_line="Available Apps: "
    current_length=${#current_line}

    docker ps --format '{{.Names}}' | grep -v 'cf_tunnel' | while read -r app; do
        app_length=${#app}
        new_length=$((current_length + app_length + 1)) # +1 for the space

        # If adding the app would exceed the maximum length, start a new line
        if [[ $new_length -gt $MAX_LINE_LENGTH ]]; then
            echo "$current_line"
            current_line="$app "
            current_length=$((app_length + 1)) # Reset with the new app and a space
        else
            current_line+="$app "
            current_length=$new_length
        fi
    done

    # Print the last line if it has content
    if [[ -n $current_line ]]; then
        echo "$current_line"
    fi
}

# Main menu function
main_menu() {
  while true; do
    clear

    # Get the number of running Docker apps, excluding cf_tunnel
    APP_COUNT=$(count_docker_apps)

    echo -e "${BLUE}PG: App Deployment – Available Apps${NC}"
    echo ""  # Blank line for separation
    # Display the list of available apps
    echo -e "${GREEN}Available Apps:${NC}"
    generate_app_list
    echo ""  # Blank line for separation

    # Display the main menu options
    echo -e "Type [${GREEN}App${NC}] to Deploy or [${RED}Exit${NC}]: "

    # Prompt the user for input
    read -p "" choice

    case $choice in
      V|v)
        running_function
        ;;
      D|d)
        deployment_function
        ;;
      Z|z)
        exit 0
        ;;
      *)
        clear
        echo "Incorrect selection. Please enter V, D, or Z."
        echo -e "[${GREEN}Press Enter${NC}] to continue..."
        read
        ;;
    esac
  done
}

# Call the main menu function
main_menu
