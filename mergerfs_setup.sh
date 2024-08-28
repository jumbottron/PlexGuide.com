#!/bin/bash

# Function to install MergerFS
install_mergerfs() {
    echo "Installing MergerFS..."
    sudo apt-get update
    sudo apt-get install -y mergerfs
    echo "MergerFS installed successfully."
}

# Function to configure MergerFS
configure_mergerfs() {
    echo "Configuring MergerFS..."
    
    # Get the source directories
    read -p "Enter the source directories to merge (space-separated): " source_dirs
    
    # Get the mount point
    read -p "Enter the mount point for the merged filesystem: " mount_point
    
    # Create the mount point if it doesn't exist
    sudo mkdir -p "$mount_point"
    
    # Create the fstab entry
    fstab_entry="$source_dirs $mount_point fuse.mergerfs defaults,allow_other,use_ino,category.create=mfs,moveonenospc=true 0 0"
    
    # Add the entry to /etc/fstab
    echo "$fstab_entry" | sudo tee -a /etc/fstab
    
    # Mount the filesystem
    sudo mount -a
    
    echo "MergerFS configuration completed."
    
    # Update Docker configuration
    update_docker_config "$mount_point"
}

# Function to update Docker configuration
update_docker_config() {
    local mount_point="$1"
    
    echo "Updating Docker configuration to use MergerFS..."
    
    # Stop Docker service
    sudo systemctl stop docker
    
    # Update Docker daemon configuration
    sudo tee /etc/docker/daemon.json > /dev/null <<EOT
{
    "data-root": "$mount_point/docker",
    "storage-driver": "overlay2"
}
EOT
    
    # Create Docker directory in the merged filesystem
    sudo mkdir -p "$mount_point/docker"
    
    # Start Docker service
    sudo systemctl start docker
    
    echo "Docker configuration updated to use MergerFS."
}

# Function to list merged drives
list_merged_drives() {
    echo "Listing merged drives:"
    grep "fuse.mergerfs" /etc/fstab
    echo "Current mounts:"
    mount | grep fuse.mergerfs
}

# Main menu
while true; do
    echo "MergerFS Setup"
    echo "1. Install MergerFS"
    echo "2. Configure MergerFS and Update Docker"
    echo "3. List Merged Drives"
    echo "4. Exit"
    read -p "Enter your choice: " choice

    case $choice in
        1)
            install_mergerfs
            ;;
        2)
            configure_mergerfs
            ;;
        3)
            list_merged_drives
            ;;
        4)
            echo "Exiting MergerFS Setup."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please try again."
            ;;
    esac
    echo
done