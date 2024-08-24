#!/bin/bash

# ANSI color codes
RED="\033[0;31m"
GREEN="\033[0;32m"
NC="\033[0m" # No color

# Function: redeploy_app
redeploy_app() {
    echo "Deploying $app_name..."
    source "/pg/apps/$app_name"  # Source the app script to load functions
    deploy_container "$app_name"  # Call the deploy_container function
    echo -e "${GREEN}${app_name}${NC} has been deployed."
    read -p "Press Enter to continue..."
}

# Deployment logic
clear
deploy_code=$(printf "%04d" $((RANDOM % 10000)))

while true; do
    read -p "$(echo -e "Deploy/Redeploy $app_name?\nType [${RED}${deploy_code}${NC}] to proceed or [${GREEN}no${NC}] to cancel: ")" deploy_choice
    if [[ "$deploy_choice" == "$deploy_code" ]]; then
        bash /pg/scripts/apps_kill_remove.sh "$app_name"  # Stop and remove app
        redeploy_app  # Deploy the container after stopping/removing
        break
    elif [[ "${deploy_choice,,}" == "no" ]]; then
        echo "Operation cancelled."
        break
    else
        echo -e "${RED}Invalid response.${NC} Please type [${RED}${deploy_code}${NC}] or [${GREEN}no${NC}]."
    fi
done
