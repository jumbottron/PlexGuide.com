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

# Display disk information with file system type, highlight the OS disk
lsblk -o NAME,SIZE,TYPE,FSTYPE,MODEL | while read -r line; do
    if [[ "$line" =~ ^$ROOT_DISK ]]; then
        echo -e "${RED}${line}${NC}"  # Highlight the OS disk in red
    else
        echo "$line"
    fi
done

# Notify the user
echo ""
echo -e "${RED}The operating system is installed on disk: $ROOT_DISK${NC}"
echo -e "Press [${GREEN}Enter${NC}] to exit."
read
