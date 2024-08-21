#!/bin/bash

# ANSI color codes
RED="\033[0;31m"
GREEN="\033[0;32m"
BLUE="\033[0;34m"
NC="\033[0m" # No color

# Function to check if Intel Top is installed
check_intel_top_installed() {
    if command -v intel_gpu_top &> /dev/null; then
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

# Function to install Intel Top
install_intel_top() {
    if command -v intel_gpu_top &> /dev/null; then
        echo "Intel Top is already installed. Upgrading to the latest version..."
        sudo apt-get update && sudo apt-get upgrade intel-gpu-tools -y
    else
        echo "Installing Intel Top..."
        sudo apt-get update && sudo apt-get install intel-gpu-tools -y
    fi
    echo -e "${GREEN}Intel Top installation/upgrade complete.${NC}"
}

# Function to uninstall Intel Top
uninstall_intel_top() {
    if command -v intel_gpu_top &> /dev/null; then
        echo "Uninstalling Intel Top..."
        sudo apt-get remove intel-gpu-tools -y
        echo -e "${GREEN}Intel Top has been uninstalled.${NC}"
    else
        echo -e "${RED}Intel Top cannot be uninstalled because it is not installed.${NC}"
    fi
}

# Main menu function
intel_top_menu() {
    while true; do
        clear
        echo -e "${BLUE}PG: Intel Top Management${NC}"
        echo -n "Status: "
        
        if check_intel_top_installed; then
            echo ""
            echo "I) Reinstall/Upgrade Intel Top"
            echo "U) Uninstall Intel Top"
        else
            echo ""
            echo "I) Install Intel Top"
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
                    install_intel_top
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
                    uninstall_intel_top
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

# Call the Intel Top menu function
intel_top_menu
