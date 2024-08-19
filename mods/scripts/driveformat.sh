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

# List available disks excluding the OS disk
echo "Available disks for formatting (excluding the OS disk):"
echo ""
lsblk -d -o NAME,SIZE,MODEL | grep -vw "$ROOT_DISK"
echo ""

# Prompt the user to select a disk
read -p "Enter the name of the disk you want to format (e.g., sdb): " DISK

# Verify that the selected disk is not the OS disk
if [[ "$DISK" == "$ROOT_DISK" ]]; then
    echo -e "${RED}Error: You cannot format the disk where the OS is installed.${NC}"
    exit 1
fi

# Prompt the user to select a file system type
echo ""
echo "Select the file system type to format the disk:"
echo "1) XFS"
echo "2) ZFS"
read -p "Enter your choice [1/2]: " FS_TYPE

# Format the disk based on the selected file system type
case $FS_TYPE in
    1)
        echo "Formatting /dev/$DISK to XFS..."
        sudo mkfs.xfs -f /dev/$DISK
        echo -e "${GREEN}Successfully formatted /dev/$DISK to XFS.${NC}"
        ;;
    2)
        echo "Formatting /dev/$DISK to ZFS..."
        sudo apt-get install -y zfsutils-linux  # Ensure ZFS tools are installed
        sudo zpool create -f zpool1 /dev/$DISK  # Create a simple ZFS pool (adjust as needed)
        echo -e "${GREEN}Successfully formatted /dev/$DISK to ZFS.${NC}"
        ;;
    *)
        echo -e "${RED}Invalid selection. No changes made.${NC}"
        exit 1
        ;;
esac
