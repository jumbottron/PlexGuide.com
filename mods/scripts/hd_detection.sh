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

# Detect all hard drives, include file system format, and highlight the OS disk
echo "PG: HardDrive Detector"
echo ""

# Loop through each disk, including file system type, and highlight the OS disk
while IFS= read -r line; do
    disk_name=$(echo $line | awk '{print $1}')
    fstype=$(lsblk -no FSTYPE "/dev/$disk_name")
    
    # Handle case where FSTYPE is empty
    if [[ -z "$fstype" ]]; then
        fstype="No file system"
    fi
    
    formatted_line=$(echo "$line" | awk -v fstype="$fstype" '{printf "%-12s %-10s %-6s %-15s %-s\n", $1, $2, $3, fstype, $4}')
    
    if [[ "$disk_name" == "$ROOT_DISK" ]]; then
        echo -e "${RED}${formatted_line}${NC}"  # Highlight the OS disk in red
    else
        echo "$formatted_line"
    fi
done < <(lsblk -d -o NAME,SIZE,TYPE,MODEL | grep -w 'disk')

# Notify the user
echo ""
echo -e "${RED}The operating system is installed on disk: $ROOT_DISK${NC}"
echo -e "Press [${GREEN}Enter${NC}] to exit."
read
