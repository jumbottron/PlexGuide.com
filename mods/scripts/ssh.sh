#!/bin/bash

# ANSI color codes
RED="\033[0;31m"
BLUE="\033[0;34m"
NC="\033[0m" # No color

# Function to check if SSH is active
check_ssh_status() {
    systemctl is-active --quiet ssh && SSH_STATUS="active" || SSH_STATUS="inactive"
}

# Function to detect the SSH port
detect_ssh_port() {
    SSH_PORT=$(ss -tuln | grep -E ':(22|[0-9]{2,5}) ' | grep ssh | awk '{print $5}' | cut -d: -f2)
    if [[ -z "$SSH_PORT" ]]; then
        SSH_PORT="unknown"
    fi
}

# Function to display the SSH status and port
display_ssh_info() {
    check_ssh_status
    detect_ssh_port
    echo -e "${BLUE}PlexGuide SSH Management${NC}"
    echo ""  # Space for separation
    echo "SSH Status: $SSH_STATUS"
    echo "SSH Port: $SSH_PORT"
    echo ""  # Space for separation
}

# Function to enable SSH
enable_ssh() {
    sudo systemctl enable ssh --now
    echo "SSH has been enabled."
    read -p "Press Enter to return to the menu..."
}

# Function to disable SSH
disable_ssh() {
    sudo systemctl disable ssh --now
    echo "SSH has been disabled."
    read -p "Press Enter to return to the menu..."
}

# Function to manage SSH port
port_management() {
    echo -n "Enter the new SSH port number: "
    read new_port
    if [[ $new_port -gt 0 && $new_port -le 65535 ]]; then
        sudo sed -i "s/^#Port 22/Port $new_port/" /etc/ssh/sshd_config
        sudo systemctl restart ssh
        echo "SSH port has been changed to $new_port."
    else
        echo -e "${RED}Invalid port number. Please enter a value between 1 and 65535.${NC}"
    fi
    read -p "Press Enter to return to the menu..."
}

# Function for the main menu
main_menu() {
  while true; do
    clear
    display_ssh_info

    # Display the main menu options
    echo "E) Enable SSH"
    echo "D) Disable SSH"
    echo "P) Port Management"
    echo "Z) Exit"
    echo ""  # Space between options and input prompt

    # Prompt the user for input
    read -p "Enter your choice [E/D/P/Z]: " choice

    case ${choice,,} in  # Convert input to lowercase for e/E, d/D, p/P, z/Z handling
      e) enable_ssh ;;
      d) disable_ssh ;;
      p) port_management ;;
      z) exit 0 ;;
      *)
        echo "Invalid option, please try again."
        read -p "Press Enter to continue..."
        ;;
    esac
  done
}

# Call the main menu function
main_menu
