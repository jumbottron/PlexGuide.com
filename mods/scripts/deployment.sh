#!/bin/bash

# ANSI color codes for green, red, blue, and orange
GREEN="\033[0;32m"
RED="\033[0;31m"
BLUE="\033[0;34m"
ORANGE="\033[0;33m"
NC="\033[0m" # No color

# Source the apps_interface function from the external script
source /pg/scripts/apps_interface

# Clear the screen at the start
clear

# Function to create the /pg/apps directory if it doesn't exist
create_apps_directory() {
    if [[ ! -d "/pg/apps" ]]; then
        mkdir -p /pg/apps
    fi
}

# Function to list all available apps in /pg/apps, excluding those already running in Docker
list_available_apps() {
    local all_apps=$(ls -1 /pg/apps | sort)
    local running_apps=$(docker ps --format '{{.Names}}' | sort)
    
    local available_apps=()
    for app in $all_apps; do
        if ! echo "$running_apps" | grep -i -w "$app" >/dev/null; then
            available_apps+=("$app")
        fi
    done

    if [[ ${#available_apps[@]} -eq 0 ]]; then
        echo -e "${ORANGE}No More Apps To Deploy${NC}"
    else
        echo "${available_apps[@]}"
    fi
}

# Function to list all active Docker containers
list_active_containers() {
    local running_apps=$(docker ps --format '{{.Names}}' | sort)

    if [[ -z "$running_apps" ]]; then
        echo -e "${ORANGE}No Apps are Running${NC}"
    else
        echo "$running_apps"
    fi
}

# Function to deploy the selected app
deploy_app() {
    local app_name=$1
    local app_path="/pg/apps/$app_name"

    # Call the apps_interface function
    apps_interface "$app_name"
}

# Function to destroy the selected app
destroy_app() {
    local app_name=$1
    local app_container=$(docker ps --filter "name=$app_name" --format "{{.ID}}")

    if [[ -n "$app_container" ]]; then
        echo "Destroying $app_name ..."
        docker stop "$app_container"
        docker rm "$app_container"

        # Notify the user that the app has been destroyed and display the app name in red
        echo ""
        echo -e "${RED}${app_name}${NC} has been destroyed."
        echo "Press any key to continue..."
        read -n 1 -s
    else
        echo "Error: The app $app_name is not running or does not exist."
        echo "Press any key to continue..."
        read -n 1 -s
    fi
}

# Function to view and manage running apps
manage_running_app() {
    clear

    RUNNING_LIST=$(list_active_containers)

    echo -e "${BLUE}PG: Active Docker Containers${NC}"
    echo ""  # Blank line for separation

    # Check if RUNNING_LIST is empty or contains the "No Apps are Running" message
    if [[ "$RUNNING_LIST" == "${ORANGE}No Apps are Running${NC}" ]]; then
        echo -e "$RUNNING_LIST"
    else
        echo -e "${GREEN}Running Apps:${NC} ${RUNNING_LIST[*]}"
    fi

    echo ""  # Blank line for separation

    if [[ "$RUNNING_LIST" != "${ORANGE}No Apps are Running${NC}" ]]; then
        read -p "$(echo -e "Type [${GREEN}App${NC}] to Manage, or [${RED}Exit${NC}]: ")" app_choice

        app_choice=$(echo "$app_choice" | tr '[:upper:]' '[:lower:]')

        if [[ "$app_choice" != "exit" ]]; then
            # Check if the app_choice matches any of the running apps exactly
            if [[ " ${RUNNING_LIST[@]} " =~ " ${app_choice} " ]]; then
                apps_interface "$app_choice"
            else
                echo "Invalid choice. Please try again."
                read -p "Press Enter to continue..."
            fi
        fi
    else
        read -p "Press Enter to return to the main menu..."
    fi
}

# Main menu function
main_menu() {
    while true; do
        clear

        create_apps_directory

        echo -e "${BLUE}PG: App Deployment - Available Apps${NC}"
        echo ""  # Blank line for separation
        echo "1) View & Manage Running Apps"
        echo "2) Deploy New App"
        echo "3) Destroy App"
        echo "4) Exit"
        echo ""  # Space between options and input prompt

        read -p "Enter your choice [1-4]: " choice

        case $choice in
            1)
                manage_running_app
                ;;
            2)
                APP_LIST=$(list_available_apps)

                echo -e "${GREEN}Available Apps:${NC} ${APP_LIST[*]}"
                echo ""  # Blank line for separation

                read -p "$(echo -e "Type [${GREEN}App${NC}] to Deploy, or [${RED}Exit${NC}]: ")" app_choice

                app_choice=$(echo "$app_choice" | tr '[:upper:]' '[:lower:]')

                if [[ "$app_choice" != "exit" ]]; then
                    # Check if the app_choice matches any of the available apps exactly
                    if [[ " ${APP_LIST[@]} " =~ " ${app_choice} " ]]; then
                        deploy_app "$app_choice"
                    else
                        echo "Invalid choice. Please try again."
                        read -p "Press Enter to continue..."
                    fi
                fi
                ;;
            3)
                read -p "Enter the name of the app to destroy: " destroy_choice
                destroy_app "$destroy_choice"
                ;;
            4)
                exit 0
                ;;
            *)
                echo "Invalid option, please try again."
                read -p "Press Enter to continue..."
                ;;
        esac
    done
}

# Call the main menu function
main_menu
