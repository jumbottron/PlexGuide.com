#!/bin/bash

# ANSI color codes
RED="\033[0;31m"
GREEN="\033[0;32m"
BLUE="\033[0;34m"
NC="\033[0m" # No color

# Function: check_deployment_status
check_deployment_status() {
    local container_status=$(docker ps --filter "name=^/${app_name}$" --format "{{.Names}}")

    if [[ "$container_status" == "$app_name" ]]; then
        echo -e "${GREEN}[Deployed]${NC} $app_name"
    else
        echo -e "${RED}[Not Deployed]${NC} $app_name"
    fi
}

# Function: stop_and_remove_app
stop_and_remove_app() {
    docker ps --filter "name=^/${app_name}$" --format "{{.Names}}" &> /dev/null
    if [[ $? -eq 0 ]]; then
        echo "Stopping and removing the existing container for $app_name ..."
        docker stop "$app_name" && docker rm "$app_name"
    else
        echo "Container $app_name is not running."
    fi
}

# Function: redeploy_app
redeploy_app() {
    echo "Deploying $app_name..."
    bash "$app_path" "$app_name"
    echo -e "${BLUE}${app_name}${NC} has been deployed."
    read -p "Press Enter to continue..."
}

# Main Function: apps_interface
apps_interface() {
    local app_name=$1
    local config_path="/pg/config/${app_name}.cfg"
    local app_path="/pg/apps/${app_name}"

    # Menu
    while true; do
        clear

        # Re-source the config file to refresh values
        source "$config_path"

        check_deployment_status  # Display the initial status
        echo ""
        echo "D) Deploy $app_name"
        echo "K) Kill Docker Container"
        echo "C) Configuration Options"
        echo "Z) Exit"
        echo ""

        read -p "Choose an option: " choice

        case ${choice,,} in  # Convert input to lowercase
            d)
                clear
                local deploy_code=$(printf "%04d" $((RANDOM % 10000)))
                while true; do
                    read -p "$(echo -e "Deploy/Redeploy $app_name?\nType [${RED}${deploy_code}${NC}] to proceed or [${GREEN}no${NC}] to cancel: ")" deploy_choice
                    if [[ "$deploy_choice" == "$deploy_code" ]]; then
                        stop_and_remove_app
                        redeploy_app  # Deploy the container after stopping/removing
                        break
                    elif [[ "${deploy_choice,,}" == "no" ]]; then
                        echo "Operation cancelled."
                        break
                    else
                        echo -e "${RED}Invalid response.${NC} Please type [${RED}${deploy_code}${NC}] or [${GREEN}no${NC}]."
                    fi
                done
                ;;
            k)
                stop_and_remove_app
                ;;
            c)
                bash /pg/scripts/apps_config_menu.sh "$app_name"
                ;;
            z)
                break
                ;;
            *)
                echo "Invalid option, please try again."
                read -p "Press Enter to continue..."
                ;;
        esac
    done
}

# Ensure the apps_interface function is called
if [[ -z "$1" ]]; then
    echo "Error: No app name provided."
    echo "Usage: $0 <app_name>"
    exit 1
else
    apps_interface "$1"
fi
