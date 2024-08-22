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

# Function: parse_and_store_defaults
parse_and_store_defaults() {
    local app_name=$1
    local app_path="/pg/apps/${app_name}"
    local config_path="/pg/config/${app_name}.cfg"

    # Check if the config file exists, create it if not
    [[ ! -f "$config_path" ]] && touch "$config_path"

    # Read through the app script for lines starting with "#####"
    while IFS= read -r line; do
        if [[ "$line" =~ ^##### ]]; then
            # Remove leading "##### " and extract the key and value
            local trimmed_line=$(echo "$line" | sed 's/^##### //')
            local key=$(echo "$trimmed_line" | cut -d':' -f1 | tr '[:upper:]' '[:lower:]' | tr ' ' '_')
            local value=$(echo "$trimmed_line" | cut -d':' -f2 | xargs)

            # Check if the key already exists in the config file, add it if not
            if ! grep -q "^$key=" "$config_path"; then
                echo "$key=$value" >> "$config_path"
            fi
        fi
    done < "$app_path"
}

# Function: execute_dynamic_menu
execute_dynamic_menu() {
    local selected_option=$1

    # Source the app script to load the functions
    echo "source /pg/apps/\"$app_name\""
    source /pg/apps/$app_name

    # Get the selected option name (e.g., "token" or "example")
    local selected_name=$(echo "${dynamic_menu_items[$((selected_option-1))]}" | awk '{print $2}')
    echo "Selected function name: $selected_name"  # Debugging: Check the function name extracted
    
    # Convert the selected_name to lowercase (functions in bash are case-sensitive)
    local function_name="${selected_name,,}"
    echo "Function name derived: $function_name"  # This will echo the function name

    # Check if the function exists and execute it
    if declare -f "$function_name" > /dev/null; then
        echo "Executing commands for ${function_name}..."
        "$function_name"  # Execute the function
    else
        echo "Error: No corresponding function found for ${function_name}."
    fi

    read -p "Press Enter to continue..."  # Pause to observe output
}


# Main Interface
apps_interface() {
    local app_name=$1
    local config_path="/pg/config/${app_name}.cfg"
    local app_path="/pg/apps/${app_name}"
    local dynamic_menu_items=()
    local dynamic_menu_count=1

    # Call parse_and_store_defaults to populate the config file
    parse_and_store_defaults "$app_name"

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
                bash /pg/scripts/apps_deploy.sh "$app_name" "$app_path"
                ;;
            k)
                bash /pg/scripts/apps_kill_remove.sh "$app_name"  # Stop and remove app
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
