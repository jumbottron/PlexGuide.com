#!/bin/bash

# ANSI color codes
RED="\033[0;31m"
GREEN="\033[0;32m"
NC="\033[0m" # No color

# Function to Reinstall PlexGuide
reinstall_plexguide() {
    clear
    local reinstall_code=$(printf "%04d" $((RANDOM % 10000)))  # Generate a 4-digit code
    while true; do
        read -p "$(echo -e "To reinstall PlexGuide, type [${RED}${reinstall_code}${NC}] to proceed or [${GREEN}Z${NC}] to cancel: ")" input_code
        if [[ "$input_code" == "$reinstall_code" ]]; then
            clear
            echo "Downloading and executing the install script..."
            curl -o /tmp/install.sh https://raw.githubusercontent.com/plexguide/PlexGuide.com/v11/mods/install/install.sh
            chmod +x /tmp/install.sh
            /tmp/install.sh
            rm -f /tmp/install.sh
            bash /pg/scripts/basics.sh
            echo "Reloading PlexGuide..."
            sleep 1
            exec plexguide
            break
        elif [[ "${input_code,,}" == "z" ]]; then
            echo "Operation cancelled."
            break
        else
            clear  # Invalid response: clear the screen and repeat the prompt
        fi
    done
}

# Call the function to reinstall PlexGuide
reinstall_plexguide
