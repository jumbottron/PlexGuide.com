#!/bin/bash

# ANSI color codes
RED="\033[0;31m"
GREEN="\033[0;32m"
BLUE="\033[0;34m"
NC="\033[0m" # No color

# Function to generate a random 4-digit code
generate_code() {
    echo $((RANDOM % 9000 + 1000))
}

# Main menu function
intel_top_menu() {
    while true; do
        clear
        echo -e "${BLUE}PG: Intel Top Management${NC}"
        echo -n "Status: "
        check_intel_top_installed
        echo ""  # Space for separation
        echo "I) Install Intel Top"
        echo "U) Uninstall Intel Top"
        echo "Z) Exit"
        echo ""  # Space between options and input prompt

        # Prompt the user for input
        read -p "Enter your choice [I/U/Z]: " choice

        case ${choice,,} in  # Convert input to lowercase for i/I, u/U, z/Z handling
            i)
                clear
                code=$(generate_code)
                echo -e "Enter the 4-digit code ${RED}$code${NC} to proceed or type [${GREEN}exit${NC}] to go back: "
                read -r input_code
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
                echo -e "Enter the 4-digit code ${RED}$code${NC} to proceed or type [${GREEN}exit${NC}] to go back: "
                read -r input_code
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
