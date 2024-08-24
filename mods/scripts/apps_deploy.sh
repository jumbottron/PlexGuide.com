#!/bin/bash

# ANSI color codes
RED="\033[0;31m"
GREEN="\033[0;32m"
NC="\033[0m" # No color

# Arguments
app_name=$1

# Function: redeploy_app
redeploy_app() {
    echo "Deploying $app_name"
    source /pg/scripts/apps_support.sh "$app_name" && appsourcing
    source "/pg/apps/$app_name/$app_name.app"  # Source the app script to load functions
    deploy_container "$app_name"  # Call the deploy_container function
}

# Deployment logic
clear
deploy_code=$(printf "%04d" $((RANDOM % 10000)))

while true; do
    clear
    echo -e "Deploy/Redeploy $app_name?"
    echo -e "Type [${RED}${deploy_code}${NC}] to proceed or [${GREEN}Z${NC}] to cancel: "
    
    read -p "" deploy_choice
    
    if [[ "$deploy_choice" == "$deploy_code" ]]; then
        bash /pg/scripts/apps_kill_remove.sh "$app_name"  # Stop and remove app
        redeploy_app  # Deploy the container after stopping/removing
        break
    elif [[ "${deploy_choice,,}" == "z" ]]; then
        echo "Operation cancelled."
        break
    fi
done
