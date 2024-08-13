#!/bin/bash

# Configuration file path
CONFIG_FILE="/pg/config/config.cfg"

# ANSI color codes for green, red, and blue
GREEN="\033[0;32m"
RED="\033[0;31m"
BLUE="\033[0;34m"
NC="\033[0m" # No color

# Clear the screen when the script starts
clear

# Function to source the configuration file
load_config() {
    if [[ -f "$CONFIG_FILE" ]]; then
        source "$CONFIG_FILE"
    fi
}

# Function to save the Cloudflare token to the config file
save_token_to_config() {
    echo "CLOUDFLARE_TOKEN=\"$CLOUDFLARE_TOKEN\"" > "$CONFIG_FILE"
}

# Load existing configuration
load_config

# Check if the Docker container is running or exists
container_running() {
    docker ps --filter "name=cf_tunnel" --format "{{.Names}}" | grep -q "cf_tunnel"
}

container_exists() {
    docker ps -a --filter "name=cf_tunnel" --format "{{.Names}}" | grep -q "cf_tunnel"
}

# Function to display the main menu
show_menu() {
    clear
    echo "PG: CloudFlare Tunnel"

    # Display container deployment status
    echo -n "Container Deployed: "
    if container_running; then
        echo -e "${GREEN}Yes${NC}"
    else
        echo -e "${RED}No${NC}"
    fi

    echo
    echo "1) View Token"
    echo "2) Change Token"
    echo "3) Deploy Container"
    if container_exists; then
        echo "4) Stop & Destroy Container"
        echo "5) Exit"
    else
        echo "4) Exit"
    fi
    echo
}

# Function to prompt the user with a choice
prompt_choice() {
    read -p "Select an option: " choice
    case $choice in
        1)
            view_token
            ;;
        2)
            change_token
            ;;
        3)
            deploy_container
            ;;
        4)
            if container_exists; then
                stop_destroy_container
            else
                exit 0
            fi
            ;;
        5)
            exit 0
            ;;
        *)
            echo "Invalid choice. Please select a valid option."
            sleep 2
            show_menu
            prompt_choice
            ;;
    esac
}

# Function to view the Cloudflare token
view_token() {
    clear
    echo "Current Cloudflare Token:"
    echo
    if [[ -z "$CLOUDFLARE_TOKEN" || "$CLOUDFLARE_TOKEN" == "null" ]]; then
        echo "No Stored Token"
    else
        echo "$CLOUDFLARE_TOKEN"
    fi
    echo
    echo -e "${BLUE}[Press Enter]${NC} to Exit"
    read
    show_menu
    prompt_choice
}

# Function to change the Cloudflare token
change_token() {
    read -p "Enter new Cloudflare token: " CLOUDFLARE_TOKEN
    save_token_to_config
    echo "Cloudflare token has been updated and saved to $CONFIG_FILE."
    sleep 2
    show_menu
    prompt_choice
}

# Function to deploy or redeploy the container
deploy_container() {
    if container_exists; then
        echo "Redeploying container..."
        docker stop cf_tunnel
        docker rm cf_tunnel
    else
        echo "Deploying container for the first time..."
    fi

    docker run -d --name cf_tunnel --restart unless-stopped \
        -e TUNNEL_TOKEN="$CLOUDFLARE_TOKEN" \
        cloudflare/cloudflared:latest
    echo "Cloudflare Tunnel Docker container deployed."
    sleep 2
    show_menu
    prompt_choice
}

# Function to stop and destroy the container
stop_destroy_container() {
    echo "Stopping and destroying the container..."
    docker stop cf_tunnel
    docker rm cf_tunnel
    echo "Container stopped and removed."
    sleep 2
    show_menu
    prompt_choice
}

# Main script execution
show_menu
prompt_choice
