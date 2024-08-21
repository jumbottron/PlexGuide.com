#!/bin/bash

# ANSI color codes
RED="\033[0;31m"
GREEN="\033[0;32m"
BLUE="\033[0;34m"
NC="\033[0m" # No color

# Function to check if NVIDIA drivers are installed
check_nvidia_drivers_installed() {
    if command -v nvidia-smi &> /dev/null; then
        echo -e "${GREEN}[Installed]${NC}"
        return 0
    else
        echo -e "${RED}[Not Installed]${NC}"
        return 1
    fi
}

# Function to generate a random 4-digit code
generate_code() {
    echo $((RANDOM % 9000 + 1000))
}

# Function to install NVIDIA drivers
install_nvidia_drivers() {
    if command -v nvidia-smi &> /dev/null; then
        echo "NVIDIA drivers are already installed. Upgrading to the latest version..."
        sudo apt-get update && sudo apt-get upgrade -y
    else
        echo "Installing NVIDIA drivers..."
        sudo apt-get update
        sudo apt-get install -y nvidia-driver-460  # Example, adjust as needed
    fi
    echo -e "${GREEN}NVIDIA drivers installation/upgrade complete.${NC}"
}

# Function to uninstall NVIDIA drivers
uninstall_nvidia_drivers() {
    if command -v nvidia-smi &> /dev/null; then
        echo "Uninstalling NVIDIA drivers..."
        sudo apt-get remove --purge nvidia-driver-* -y
        echo -e "${GREEN}NVIDIA drivers have been uninstalled.${NC}"
    else
        echo -e "${RED}NVIDIA drivers cannot be uninstalled because they are not installed.${NC}"
    fi
}

# Main menu function
nvidia_drivers_menu() {
    while true; do
        clear
        echo -e "${BLUE}PG: NVIDIA Drivers Management${NC}"
        echo -n "Status: "
        
        if check_nvidia_drivers_installed; then
            echo ""
            echo "I) Reinstall/Upgrade NVIDIA Drivers"
            echo "U) Uninstall NVIDIA Drivers"
        else
            echo ""
            echo "I) Install NVIDIA Drivers"
        fi
        
        echo "Z) Exit"
        echo ""  # Space between options and input prompt

        # Prompt the user for input
        read -p "Enter your choice: " choice

        case ${choice,,} in  # Convert input to lowercase for i/I, u/U, z/Z handling
            i)
                clear
                code=$(generate_code)
                read -p "$(echo -e "Enter the 4-digit code [${RED}${code}${NC}] to proceed or [${GREEN}exit${NC}] to go back: ")" input_code
                if [[ "$input_code" == "$code" ]]; then
                    install_nvidia_drivers
                elif [[ "${input_code,,}" == "exit" ]]; then
                    continue
                else
                    echo "Incorrect code. Returning to the menu..."
                fi
                read -p "Press Enter to continue..."
                ;;
            u)
                clear
                code=$(generate_code)
                read -p "$(echo -e "Enter the 4-digit code [${RED}${code}${NC}] to proceed or [${GREEN}exit${NC}] to go back: ")" input_code
                if [[ "$input_code" == "$code" ]]; then
                    uninstall_nvidia_drivers
                elif [[ "${input_code,,}" == "exit" ]]; then
                    continue
                else
                    echo "Incorrect code. Returning to the menu..."
                fi
                read -p "Press Enter to continue..."
                ;;
            z)
                echo "Returning to the previous menu..."
                break
                ;;
            *)
                echo "Invalid option, please try again."
                read -p "Press Enter to continue..."
                ;;
        esac
    done
}

# Call the NVIDIA Drivers menu function
nvidia_drivers_menu
