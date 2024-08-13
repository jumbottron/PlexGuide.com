#!/bin/bash

# ANSI color codes for green, red, and blue
GREEN="\033[0;32m"
RED="\033[0;31m"
BLUE="\033[0;34m"
NC="\033[0m" # No color

# Function to count running Docker containers, excluding cf_tunnel
count_docker_apps() {
    docker ps --format '{{.Names}}' | grep -v 'cf_tunnel' | wc -l
}

# Main menu function
main_menu() {
  while true; do
    clear

    # Get the number of running Docker apps, excluding cf_tunnel
    APP_COUNT=$(count_docker_apps)

    echo -e "${BLUE}PG: Docker Apps${NC}"
    echo ""  # Blank line for separation
    # Display the main menu options
    echo "1) View Deployed Apps [ $APP_COUNT ]"
    echo -e "2) Apps [${GREEN}Deploy${NC}]"
    echo -e "3) Apps [${RED}Destroy${NC}]"
    echo "4) Exit"
    echo ""  # Space between options and input prompt

    # Prompt the user for input
    read -p "Enter your choice [1-4]: " choice

    case $choice in
      1)
        /pg/scripts/running.sh
        ;;
      2)
        /pg/scripts/deployment.sh
        ;;
      3)
        /pg/scripts/destroy.sh
        ;;
      4)
        exit 0
        ;;
      *)
        clear
        echo ""  # Blank line for separation
        echo "Incorrect selection. Please enter a number between 1 and 4."
        echo -e "[${GREEN}Press Enter${NC}] to continue..."
        read
        ;;
    esac
  done
}

# Call the main menu function
main_menu
