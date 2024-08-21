#!/bin/bash

# ANSI color codes
RED="\033[0;31m"
GREEN="\033[0;32m"
NC="\033[0m" # No color

# Function to check open ports on the firewall and format the output
check_firewall_open_ports() {
    clear
    echo -e "${RED}PG: Firewall Open Ports Checker${NC}"
    echo

    # Gather the list of unique open ports
    open_ports=$(sudo ufw status | grep -i "allow" | awk '{print $1}' | sed 's/\/.*//' | sort -n | uniq | tr '\n' ',' | sed 's/,$//')

    # Wrap open ports to fit within an 80-character width
    max_width=80
    current_line=""
    for port in ${open_ports//,/ }; do
        if [ ${#current_line} -eq 0 ]; then
            current_line="$port"
        elif [ $((${#current_line} + ${#port} + 2)) -lt $max_width ]; then
            current_line+=", $port"
        else
            echo "$current_line"
            current_line="$port"
        fi
    done

    # Print the last line if it exists
    [ -n "$current_line" ] && echo "$current_line"

    # Print the separator line (80 characters long)
    echo "════════════════════════════════════════════════════════════════════════════════"

    echo -e "Press [${GREEN}Enter${NC}] to Exit"
}

# Call the function
check_firewall_open_ports

# Prompt to exit
read -p "" dummy
