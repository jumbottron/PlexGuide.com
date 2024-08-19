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

# Generate random 4-digit codes for "yes" and "no"
yes_code=$(printf "%04d" $((RANDOM % 10000)))
no_code=$(printf "%04d" $((RANDOM % 10000)))

# Display the prompt
echo -e "${BLUE}Expose Port Configuration for ${app_name}${NC}"
echo ""
echo "Current Setting: ${expose:-"Port Exposed"}"
echo ""
printf "Would you like to expose the port?\n"
printf " - Type [${GREEN}${yes_code}${NC}] to expose the port. (access remotely)\n"
printf " - Type [${RED}${no_code}${NC}] to keep it private (127.0.0.1; localhost only).\n"
echo ""

# Prompt the user for input and validate
while true; do
    read -p "Type [${yes_code}] [${no_code}] or [exit]: " user_input
    if [[ "$user_input" == "$yes_code" ]]; then
        echo "Port will be exposed."
        break
    elif [[ "$user_input" == "$no_code" ]]; then
        echo "Port will remain private."
        break
    elif [[ "$user_input" == "exit" ]]; then
        echo "Operation cancelled."
        break
    else
        echo "Invalid input. Please try again."
    fi
done
