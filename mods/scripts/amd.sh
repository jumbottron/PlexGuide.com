#!/bin/bash

# ANSI color codes
RED="\033[0;31m"
GREEN="\033[0;32m"
BLUE="\033[0;34m"
NC="\033[0m" # No color

# Function to check if AMD drivers are installed
check_amd_drivers_installed() {
    if command -v amdgpu-pro &> /dev/null || dpkg -l | grep -q amdgpu; then
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

# Function to install AMD drivers
install_amd_drivers() {
    if command -v amdgpu-pro &> /dev/null || dpkg -l | grep -q amdgpu; then
        echo "AMD drivers are already installed. Upgrading to the latest version..."
        sudo apt-get update && sudo apt-get upgrade amdgpu-pro -y
    else
        echo "Installing AMD drivers..."
        sudo apt-get update
        sudo apt-get install -y amdgpu-pro  # Use the appropriate package for your system
    fi
    echo -e "${GREEN}AMD drivers installation/upgrade complete.${NC}"
}

# Function to uninstall AMD drivers
uninstall_amd_drivers() {
    if command -v amdgpu-pro &> /dev/null || dpkg -l | grep -q amdgpu; then
        echo "Uninstalling AMD drivers..."
        sudo apt-get remove --purge amdgpu-pro amdgpu -y
        echo -e "${GREEN}AMD drivers have been uninstalled.${NC}"
    else
        echo -e "${RED}AMD drivers cannot be uninstalled because they are not installed.${NC}"
    fi
}

# Main menu function
amd_drivers_menu() {
    while true; do
        clear
        echo -e "${BLUE}PG: AMD Drivers Management${NC}"
        echo -n "Status: "
        
        if check_amd_drivers_installed; then
            echo ""
            echo "I) Reinstall/Upgrade AMD Drivers"
            echo "U) Uninstall AMD Drivers"
        else
            echo ""
            echo "I) Install AMD Drivers"
        fi
        
        echo "Z) Exit"
        echo ""  # Space between options and input prompt

        # Prompt the user for input
        read -p "Enter your choice: " choice

        case ${choice,,} in  # Convert input to lowercase for i/I, u/U, z/Z handling
            i)
                clear
                code=$(generate_code)
                echo -e "Enter the 4-digit code ${RED}$code${NC} to proceed or type [${GREEN}exit${NC}] to go back: "
                read -r input_code
                if [[ "$input_code" == "$code" ]]; then
                    install_amd_drivers
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
                echo -e "Enter the 4-digit code ${RED}$code${NC} to proceed or type [${GREEN}exit${NC}] to go back: "
                read -r input_code
                if [[ "$input_code" == "$code" ]]; then
                    uninstall_amd_drivers
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

# Call the AMD Drivers menu function
amd_drivers_menu
