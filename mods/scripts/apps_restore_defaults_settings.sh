#!/bin/bash

# ANSI color codes
RED="\033[0;31m"
GREEN="\033[0;32m"
NC="\033[0m" # No color

# Function: reset_config_file
reset_config_file() {
    local app_name="$1"
    local config_path="/pg/config/${app_name}.cfg"

    clear
    local reset_code=$(printf "%04d" $((RANDOM % 10000)))
    echo -e "${RED}Warning: This is an advanced option.${NC}"
    echo "Visit https://plexguide.com/wiki/link-not-set for more information."
    echo ""
    echo "This will erase the current config file and restore a default config file."
    echo "The Docker container will be stopped and removed if running."
    echo "This will not erase any data; your data will remain in its original location."
    echo ""
    while true; do
        read -p "$(echo -e "Do you want to proceed? Type [${RED}${reset_code}${NC}] to proceed or [${GREEN}no${NC}] to cancel: ")" reset_choice
        if [[ "$reset_choice" == "$reset_code" ]]; then
            # Stop and remove the Docker container
            docker stop "$app_name" && docker rm "$app_name"
            echo "Docker container $app_name has been stopped and removed."
            
            # Reset the config file
            rm -f "$config_path"
            echo "Config file has been reset to default."
            touch "$config_path"
            parse_and_store_defaults "$app_name"
            echo "The config file has been regenerated."
            read -p "Press Enter to continue..."
            return
        elif [[ "${reset_choice,,}" == "no" ]]; then
            echo "Operation Cancelled."
            return
        else
            echo -e "${RED}Invalid response.${NC} Please type [${RED}${reset_code}${NC}] or [${GREEN}no${NC}]."
        fi
    done
}
