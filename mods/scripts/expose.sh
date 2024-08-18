#!/bin/bash

# External script to handle exposing the app's port

# ANSI color codes
RED="\033[0;31m"
GREEN="\033[0;32m"
BLUE="\033[0;34m"
NC="\033[0m" # No color

app_name="$1"
config_path="/pg/config/${app_name}.cfg"

clear

# Default to expose="" if not set in config
if ! grep -q '^expose=' "$config_path"; then
    echo "expose=\"\"" >> "$config_path"
fi

# Source the config to get the current expose setting
source "$config_path"

echo -e "${BLUE}Expose Port Configuration for ${app_name}${NC}"
echo ""
echo "Current Setting: ${expose:-"Not Set"}"
echo ""
echo "Would you like to expose the port?"
echo " - Type [${GREEN}yes${NC}] to expose the port."
echo " - Type [${RED}no${NC}] to keep it private (127.0.0.1 only)."
echo " - Type [exit] to cancel."

read -p "Your choice: " choice

case ${choice,,} in  # Convert input to lowercase
    yes)
        sed -i 's/^expose=.*/expose=""/' "$config_path"
        echo -e "${GREEN}Port will be exposed globally.${NC}"
        ;;
    no)
        sed -i 's/^expose=.*/expose="127.0.0.1:"/' "$config_path"
        echo -e "${RED}Port will be restricted to 127.0.0.1.${NC}"
        ;;
    exit)
        echo "Operation cancelled."
        ;;
    *)
        echo -e "${RED}Invalid choice.${NC} Please try again."
        ;;
esac

read -p "Press Enter to return to the menu..."
