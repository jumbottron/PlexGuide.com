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

# Function: execute_dynamic_menu
execute_dynamic_menu() {
    local selected_option=$1

    # Source the app script to load the functions
    source "$app_path"

    # Get the selected option name (e.g., "Token" or "Example")
    local selected_name=$(echo "${dynamic_menu_items[$((selected_option-1))]}" | awk '{print $2}')

    # Check if the function exists and execute it
    if declare -f "${selected_name,,}_command" > /dev/null; then
        echo "Executing commands for ${selected_name}..."
        "${selected_name,,}_command"
    else
        echo "Error: No corresponding function found for ${selected_name}."
        read -p "Press Enter to continue..."
    fi
}

# Main Interface
apps_interface() {
    local app_name=$1
    local config_path="/pg/config/${app_name}.cfg"
    local app_path="/pg/apps/${app_name}"
    local dynamic_menu_items=()
    local dynamic_menu_count=1

    # Parse the app script for dynamic menu items
    while IFS= read -r line; do
        if [[ "$line" =~ ^####\  ]]; then
            dynamic_menu_items+=("${dynamic_menu_count}) $(echo "$line" | awk '{print $2}')")
            ((dynamic_menu_count++))
        fi
    done < "$app_path"

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
        
        # Print dynamic menu items if any
        for item in "${dynamic_menu_items[@]}"; do
            echo "$item"
        done
        
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
            [0-9]*)
                if [[ $choice -le ${#dynamic_menu_items[@]} ]]; then
                    execute_dynamic_menu "$choice"
                else
                    echo "Invalid option, please try again."
                    read -p "Press Enter to continue..."
                fi
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

# Run the interface with the provided app name
apps_interface "$1"
