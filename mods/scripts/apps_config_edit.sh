#!/bin/bash

# ANSI color codes
RED="\033[0;31m"
GREEN="\033[0;32m"
NC="\033[0m" # No color

app_name=$1
config_path=$2

# Function to wrap text at 80 characters, preserving sentence flow
wrap_text() {
    local text="$1"
    local wrapped_text=""
    local line=""

    while IFS= read -r word; do
        if [[ $(( ${#line} + ${#word} + 1 )) -gt 80 ]]; then
            wrapped_text+="$line\n"
            line="$word "
        else
            line+="$word "
        fi
    done <<< "$(echo "$text" | tr ' ' '\n')"

    wrapped_text+="$line"
    echo -e "$wrapped_text"
}

clear
edit_code=$(printf "%04d" $((RANDOM % 10000)))
wrap_text "${RED}Warning: This is an advanced option.${NC}"
wrap_text "Visit https://plexguide.com/wiki/not-generated-yet for more information."
echo ""
wrap_text "If the container is running, it will be stopped/killed and removed due to the changes made. You will need to redeploy the container manually. Once changes are made, press CTRL+X to save and exit."
echo ""
wrap_text "Do you want to proceed? Type [${RED}${edit_code}${NC}] to proceed or [${GREEN}no${NC}] to cancel: "

while true; do
    read -p "$(wrap_text "Do you want to proceed? Type [${RED}${edit_code}${NC}] to proceed or [${GREEN}no${NC}] to cancel: ")" edit_choice
    if [[ "$edit_choice" == "$edit_code" ]]; then
        nano "$config_path"

        # Stop and remove the Docker container if running
        docker ps --filter "name=^/${app_name}$" --format "{{.Names}}" &> /dev/null
        if [[ $? -eq 0 ]]; then
            wrap_text "Stopping and removing the existing container for $app_name ..."
            docker stop "$app_name" && docker rm "$app_name"
        else
            wrap_text "Container $app_name is not running."
        fi

        break
    elif [[ "${edit_choice,,}" == "no" ]]; then
        wrap_text "Operation cancelled."
        break
    else
        wrap_text "${RED}Invalid response.${NC} Please type [${RED}${edit_code}${NC}] or [${GREEN}no${NC}]."
    fi
done
