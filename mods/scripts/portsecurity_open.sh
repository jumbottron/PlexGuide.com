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

# Function to check if a port is open
is_port_open() {
    local port=$1
    if ss -tuln | grep -q ":$port "; then
        return 0
    else
        return 1
    fi
}

# Function to validate the port number
validate_port() {
    local port=$1
    if [[ $port -ge 1 && $port -le 65535 ]]; then
        return 0
    else
        echo -e "${RED}Invalid port number. Please enter a valid port between 1 and 65535.${NC}"
        return 1
    fi
}

# Function to open a port
open_port() {
    clear
    echo -e "${BLUE}PG: PortSecurity - Open Port${NC}"
    echo

    read -p "Enter the port number you would like to open: " port_number

    if is_port_open $port_number; then
        echo -e "${RED}Port $port_number is already open.${NC}"
        read -p "Press Enter to return..."
        exit 0
    fi

    if ! validate_port $port_number; then
        read -p "Press Enter to return..."
        exit 1
    fi

    clear
    echo "Type the 4-digit code to confirm opening port $port_number."
    code=$(generate_code)
    read -p "$(echo -e "Enter the 4-digit code [${RED}${code}${NC}] to proceed or [${GREEN}exit${NC}] to cancel: ")" input_code

    if [[ "$input_code" == "$code" ]]; then
        # Command to open the port (e.g., using UFW or iptables)
        echo -e "${GREEN}Port $port_number has been opened.${NC}"
        # Example: sudo ufw allow $port_number
    elif [[ "${input_code,,}" == "exit" ]]; then
        echo "Operation cancelled."
    else
        echo "Incorrect code. Operation aborted."
    fi

    read -p "Press Enter to return..."
}

# Call the open_port function
open_port
