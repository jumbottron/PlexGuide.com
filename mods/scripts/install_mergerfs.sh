#!/bin/bash

# ANSI color codes
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
NC="\033[0m" # No color

# Function to install MergerFS
install_mergerfs() {
    echo -e "${YELLOW}Installing MergerFS...${NC}"
    if ! sudo apt-get update && sudo apt-get install -y mergerfs; then
        echo -e "${RED}Error: Failed to install MergerFS. Please check your internet connection and try again.${NC}"
        exit 1
    fi
    echo -e "${GREEN}MergerFS installed successfully.${NC}"
}

# Function to configure MergerFS
configure_mergerfs() {
    echo -e "${YELLOW}Configuring MergerFS...${NC}"
    
    # Define default directories and mount point
    local source_dirs="/mnt/drive1:/mnt/drive2:/mnt/drive3"
    local mount_point="/mnt/mergedfs"
    
    # Create the mount point if it doesn't exist
    sudo mkdir -p "$mount_point"
    
    # Create the fstab entry
    local fstab_entry="$source_dirs $mount_point fuse.mergerfs defaults,allow_other,use_ino,category.create=mfs,moveonenospc=true 0 0"
    
    # Add the entry to /etc/fstab if it doesn't exist
    if ! grep -q "$mount_point" /etc/fstab; then
        echo "$fstab_entry" | sudo tee -a /etc/fstab
    fi
    
    # Mount the filesystem
    sudo mount -a
    
    echo -e "${GREEN}MergerFS configuration completed.${NC}"
    echo -e "${YELLOW}Default configuration:${NC}"
    echo "Source directories: $source_dirs"
    echo "Mount point: $mount_point"
    echo -e "${YELLOW}You can modify these settings in /etc/fstab if needed.${NC}"
}

# Main function
main() {
    install_mergerfs
    configure_mergerfs
    echo -e "${GREEN}MergerFS installation and configuration completed successfully.${NC}"
}

# Run the main function
main