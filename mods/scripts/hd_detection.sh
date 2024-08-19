#!/bin/bash

# ANSI color codes
RED="\033[0;31m"
GREEN="\033[0;32m"
NC="\033[0m" # No color

# Clear the screen at the start
clear

# Check if lsblk is installed
if ! command -v lsblk &> /dev/null; then
    echo "lsblk is not installed. Installing now..."
    sudo apt-get update
    sudo apt-get install -y util-linux
    echo "lsblk has been installed."
fi

# Detect the root partition and its parent disk
ROOT_PARTITION=$(lsblk -no NAME,MOUNTPOINT | grep -w / | awk '{print $1}')
ROOT_DISK=$(lsblk -no PKNAME "/dev/$ROOT_PARTITION")

# Store disk information in variables
disk_info=$(lsblk -o NAME,SIZE,TYPE,FSTYPE,MODEL | awk '{printf "%-10s %-7s %-5s %-7s %s\n", $1, $2, $3, $4, $5}')
formatted_disk_info=""

# Format each line of disk information
while IFS= read -r line; do
    disk_name=$(echo "$line" | awk '{print $1}')
    if [[ "$disk_name" == "$ROOT_DISK" ]]; then
        formatted_disk_info+=$(echo -e "${RED}${line}${NC}\n")  # Highlight the OS disk in red
    else
        formatted_disk_info+="$line\n"
    fi
done <<< "$disk_info"

# Output the results
echo "PG: HardDrive Detector"
echo ""
echo "$formatted_disk_info"
echo ""
echo -e "The operating system is installed on disk: ${RED}${ROOT_DISK}${NC}"
echo -e "Press [${GREEN}Enter${NC}] to exit."
read
