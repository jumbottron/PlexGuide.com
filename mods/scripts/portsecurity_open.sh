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
    if sudo ufw status | grep -q "$port"; then
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

# Function to print wrapped text with color support
print_wrapped_text() {
    local text="$1"
    local color="$2"
    echo -e "$color$(echo "$text" | fold -s -w 80)$NC"
}

# Function to open a port for both IPv4 and IPv6, TCP and UDP
open_port() {
    clear
    print_wrapped_text "PG: Firewall Security - Open Port" "$BLUE"
    echo
    print_wrapped_text "WARNING: This is an advanced configuration." "$RED"
    print_wrapped_text "For simplicity, if you open a port it will open it for IPv4 and IPv6 addresses and for TCP and UDP." "$NC"
    print_wrapped_text "Understand the consequences of opening a firewall port and the security risk involved behind it." "$NC"
    echo

    read -p "$(echo -e "Enter the port number you would like to open or type [${GREEN}exit${NC}] to cancel: ")" port_number

    if [[ "${port_number,,}" == "exit" ]]; then
        echo "Operation cancelled."
        exit 0
    fi

    if is_port_open $port_number; then
        print_wrapped_text "Port $port_number is already open." "$RED"
        read -p "Press Enter to return..."
        exit 0
    fi

    if ! validate_port $port_number; then
        read -p "Press Enter to return..."
        exit 1
    fi

    echo
    code=$(generate_code)
    read -p "$(echo -e "Enter the 4-digit code [${RED}${code}${NC}] to proceed or [${GREEN}exit${NC}] to cancel: ")" input_code

    if [[ "$input_code" == "$code" ]]; then
        # Command to open the port for both IPv4/IPv6 and TCP/UDP
        sudo ufw allow $port_number/tcp
        sudo ufw allow $port_number/udp
        print_wrapped_text "Port $port_number has been opened for TCP and UDP on both IPv4 and IPv6." "$GREEN"
    elif [[ "${input_code,,}" == "exit" ]]; then
        print_wrapped_text "Operation cancelled." "$NC"
    else
        print_wrapped_text "Incorrect code. Operation aborted." "$NC"
    fi

    read -p "Press Enter to return..."
}

# Call the open_port function
open_port
