#!/bin/bash

# ANSI color codes
RED="\033[0;31m"
GREEN="\033[0;32m"
NC="\033[0m" # No color

app_name=$1
config_path=$2

clear
edit_code=$(printf "%04d" $((RANDOM % 10000)))

echo -e "${RED}Warning: This is an advanced option.${NC}"
echo "Visit https://plexguide.com/wiki/not-generated-yet for more information."
echo ""
echo "If the container is running, it will be stopped/killed and removed due to the"
echo "changes made. You will need to redeploy the container manually. Once changes"
echo "are made, press CTRL+X to save and exit."
echo ""
echo -e "Do you want to proceed? Type [${RED}${edit_code}${NC}] to proceed or [${GREEN}no${NC}] to cancel: "

while true; do
    read -p "" edit_choice
    if [[ "$edit_choice" == "$edit_code" ]]; then
        nano "$config_path"

        # Stop and remove the Docker container if running
        docker ps --filter "name=^/${app_name}$" --format "{{.Names}}" &> /dev/null
        if [[ $? -eq 0 ]]; then
            echo "Stopping and removing the existing container for $app_name ..."
            docker stop "$app_name" && docker rm "$app_name"
        else
            echo "Container $app_name is not running."
        fi

        break
    elif [[ "${edit_choice,,}" == "no" ]]; then
        echo "Operation cancelled."
        break
    else
        echo -e "${RED}Invalid response.${NC} Please type [${RED}${edit_code}${NC}] or [${GREEN}no${NC}]."
    fi
done
