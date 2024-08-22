#!/bin/bash

# ANSI color codes
RED="\033[0;31m"
GREEN="\033[0;32m"
NC="\033[0m" # No color

app_name=$1
config_path="/pg/config/${app_name}.cfg"
app_path="/pg/apps/${app_name}"

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

# Function: get_or_set_port_number
get_or_set_port_number() {
    if ! grep -q '^port_number=' "$config_path"; then
        port_number=$(awk '/# Default Port:/ {print $NF}' "$app_path")
        [[ -n "$port_number" ]] && echo "port_number=${port_number}" >> "$config_path" || {
            echo "Error: Default port not found in $app_path."
            exit 1
        }
    else
        source "$config_path"
    fi
}

# Function: validate_or_create_path
validate_or_create_path() {
    [[ -d "$1" ]] || mkdir -p "$1" || return 1
    return 0
}

# Function: check_deployment_status
check_deployment_status() {
    local container_status=$(docker ps --filter "name=^/${app_name}$" --format "{{.Names}}")
    if [[ "$container_status" == "$app_name" ]]; then
        echo -e "${GREEN}[Deployed]${NC}"
    else
        echo -e "${RED}[Not Deployed]${NC}"
    fi
}

# Function: change_port_number
change_port_number() {
    clear
    local port_code=$(printf "%04d" $((RANDOM % 10000)))
    echo "Current Port: $port_number - Do you want to change the port number?"
    echo ""
    while true; do
        read -p "$(echo -e "Type [${RED}${port_code}${NC}] to proceed or [${GREEN}no${NC}] to cancel: ")" port_choice
        if [[ "$port_choice" == "$port_code" ]]; then
            break
        elif [[ "${port_choice,,}" == "no" ]]; then
            echo "Operation cancelled."
            return
        else
            echo -e "${RED}Invalid response.${NC} Please type [${RED}${port_code}${NC}] or [${GREEN}no${NC}]."
        fi
    done
    read -p "Enter the new Port for $app_name (1-65000) or type [exit] to cancel: " new_port_number

    if [[ "$new_port_number" =~ ^[0-9]+$ ]] && ((new_port_number >= 1 && new_port_number <= 65000)); then
        sed -i "s/^port_number=.*/port_number=${new_port_number}/" "$config_path"
        stop_and_remove_app
        redeploy_app
    elif [[ "$new_port_number" == "exit" ]]; then
        echo "No changes made."
    else
        echo "Invalid input. Please enter a number between 1 and 65000."
        read -p "Press Enter to continue..."
        change_port_number  # Recursive call to retry port change
    fi
}

# Function: move_or_delete_appdata
move_or_delete_appdata() {
    if [[ -z "$(ls -A "$appdata_path")" ]]; then
        echo "The current appdata directory is empty. No data will be moved."
    else
        read -p "Do you want to move the prior appdata to the new location? Type: yes / no / exit: " move_choice
        case ${move_choice,,} in  # Convert input to lowercase
            yes)
                mv "$appdata_path/"* "$1/" && echo "Data moved to the new location: $1"
                ;;
            no)
                read -p "Do you want to delete the old appdata? Type: yes / no: " delete_choice
                [[ ${delete_choice,,} == "yes" ]] && rm -rf "$appdata_path" && echo "Old appdata deleted."
                ;;
            exit)
                echo "Operation aborted."
                return
                ;;
            *)
                echo "Invalid input. Operation aborted."
                return
                ;;
        esac
    fi
    appdata_path=$1
    sed -i "s|^appdata_path=.*|appdata_path=${appdata_path}|" "$config_path"
}

# Function: change_appdata_path
change_appdata_path() {
    clear
    local path_code=$(printf "%04d" $((RANDOM % 10000)))
    echo "Current Appdata Path: $appdata_path"
    echo "Do you want to change the appdata path?"
    echo ""
    while true; do
        read -p "$(echo -e "Type [${RED}${path_code}${NC}] to proceed or [${GREEN}no${NC}] to cancel: ")" change_choice
        if [[ "$change_choice" == "$path_code" ]]; then
            break
        elif [[ "${change_choice,,}" == "no" ]]; then
            echo "Operation cancelled."
            return
        else
            echo -e "${RED}Invalid response.${NC} Please type [${RED}${path_code}${NC}] or [${GREEN}no${NC}]."
        fi
    done
    while true; do
        read -p "Enter the new Appdata Path for $app_name or type [exit] to cancel: " new_appdata_path

        if [[ "$new_appdata_path" == "exit" ]]; then
            echo "No changes made."
            return
        elif validate_or_create_path "$new_appdata_path"; then
            move_or_delete_appdata "$new_appdata_path"
            stop_and_remove_app
            redeploy_app
            break
        else
            echo "Invalid path. Please provide a valid path."
            read -p "Press Enter to continue..."
        fi
    done
}

# Function: reset_config_file
reset_config_file() {
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

# Function: check_expose_status
check_expose_status() {
    local expose_status="Unknown"

    if [[ -f "$config_path" ]]; then
        source "$config_path"
        
        if [[ "$expose" == "127.0.0.1:" ]]; then
            expose_status="No - Closed/Internal"
        elif [[ "$expose" == "" ]]; then
            expose_status="Yes - Remote Accessible"
        fi
    else
        echo "Error: Configuration file for $app_name not found."
        exit 1
    fi

    echo "$expose_status"
}

# Menu
while true; do
    clear

    # Re-source the config file to refresh values
    source "$config_path"

    # Get deployment status and expose status
    deployment_status=$(check_deployment_status)
    expose_status=$(check_expose_status)

    echo -e "Configuration Interface - ${app_name} ${deployment_status}"
    echo ""
    echo "A) Appdata Path: $appdata_path"
    echo "P) Port: $port_number"
    echo "C) Config File - Edit"
    echo "E) Exposed Port: $expose_status"
    echo "Y) Default the Config File"
    echo "Z) Exit"
    echo ""

    read -p "Choose an option: " choice

    case ${choice,,} in  # Convert input to lowercase
        a)
            change_appdata_path
            ;;
        p)
            change_port_number
            ;;
        c)
            nano "$config_path"
            ;;
        e)
            # Logic to modify exposed port settings can be added here
            ;;
        y)
            reset_config_file
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
