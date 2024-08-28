#!/bin/bash

LOG_FILE="/var/log/cloud_drives_setup.log"

# Function to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Function to install rclone
install_rclone() {
    log_message "Installing rclone..."
    if ! sudo apt-get update && sudo apt-get install -y rclone; then
        log_message "Error: Failed to install rclone. Please check your internet connection and try again."
        return 1
    fi
    log_message "rclone installed successfully."
}

# Function to update rclone
update_rclone() {
    log_message "Updating rclone..."
    if ! sudo rclone selfupdate; then
        log_message "Error: Failed to update rclone. Please check your internet connection and try again."
        return 1
    fi
    log_message "rclone updated successfully."
}

# Function to configure cloud drive
configure_cloud_drive() {
    log_message "Configuring cloud drive..."
    
    echo "Select a cloud provider:"
    echo "1. Google Drive"
    echo "2. OneDrive"
    echo "3. Dropbox"
    echo "4. Other (manual configuration)"
    read -p "Enter your choice (1-4): " provider_choice

    case $provider_choice in
        1) provider="drive";;
        2) provider="onedrive";;
        3) provider="dropbox";;
        4) provider="";;
        *) log_message "Invalid choice. Please try again."; return 1;;
    esac

    if [ -n "$provider" ]; then
        rclone config create myremote $provider
    else
        rclone config
    fi

    if [ $? -ne 0 ]; then
        log_message "Error: Cloud drive configuration failed. Please try again."
        return 1
    fi
    
    log_message "Cloud drive configuration completed."
}

# Function to mount cloud drive
mount_cloud_drive() {
    log_message "Mounting cloud drive..."
    
    read -p "Enter the rclone remote name: " remote_name
    read -p "Enter the mount point for the cloud drive: " mount_point
    
    if ! sudo mkdir -p "$mount_point"; then
        log_message "Error: Failed to create mount point. Please check your permissions and try again."
        return 1
    fi
    
    if ! rclone mount "$remote_name:/" "$mount_point" --daemon; then
        log_message "Error: Failed to mount cloud drive. Please check your configuration and try again."
        return 1
    fi
    
    log_message "Cloud drive mounted successfully."
    
    log_message "Adding mount to /etc/fstab for persistence..."
    if ! echo "$remote_name:/ $mount_point fuse.rclone rw,allow_other,auto,user,_netdev 0 0" | sudo tee -a /etc/fstab > /dev/null; then
        log_message "Error: Failed to add mount to /etc/fstab. Please check your permissions and try again."
        return 1
    fi
    
    log_message "Cloud drive mount added to /etc/fstab."

    integrate_with_mergerfs "$mount_point"
}

# Function to unmount cloud drive
unmount_cloud_drive() {
    log_message "Unmounting cloud drive..."
    
    read -p "Enter the mount point of the cloud drive to unmount: " mount_point
    
    if ! sudo umount "$mount_point"; then
        log_message "Error: Failed to unmount cloud drive. Please check if it's in use and try again."
        return 1
    fi
    
    log_message "Removing mount from /etc/fstab..."
    if ! sudo sed -i "\|$mount_point|d" /etc/fstab; then
        log_message "Error: Failed to remove mount from /etc/fstab. Please check your permissions and try again."
        return 1
    fi
    
    log_message "Cloud drive unmounted successfully and removed from /etc/fstab."

    remove_from_mergerfs "$mount_point"
}

# Function to integrate cloud drive with MergerFS
integrate_with_mergerfs() {
    local cloud_mount="$1"
    
    log_message "Integrating cloud drive with MergerFS..."
    
    if ! grep -q "fuse.mergerfs" /etc/fstab; then
        log_message "Error: MergerFS is not configured. Please set up MergerFS first."
        return 1
    fi
    
    local mergerfs_line=$(grep "fuse.mergerfs" /etc/fstab)
    local mergerfs_sources=$(echo "$mergerfs_line" | awk '{print $1}')
    local mergerfs_mount=$(echo "$mergerfs_line" | awk '{print $2}')
    
    local new_sources="$mergerfs_sources:$cloud_mount"
    
    if ! sudo sed -i "s|$mergerfs_line|$new_sources $mergerfs_mount fuse.mergerfs defaults,allow_other,use_ino,category.create=mfs,moveonenospc=true 0 0|" /etc/fstab; then
        log_message "Error: Failed to update MergerFS configuration in /etc/fstab."
        return 1
    fi
    
    if ! sudo mount -a; then
        log_message "Error: Failed to remount MergerFS. Please check your configuration and try again."
        return 1
    fi
    
    log_message "Cloud drive successfully integrated with MergerFS."
}

# Function to remove cloud drive from MergerFS
remove_from_mergerfs() {
    local cloud_mount="$1"
    
    log_message "Removing cloud drive from MergerFS..."
    
    if ! grep -q "fuse.mergerfs" /etc/fstab; then
        log_message "Error: MergerFS is not configured. No action needed."
        return 0
    fi
    
    local mergerfs_line=$(grep "fuse.mergerfs" /etc/fstab)
    local mergerfs_sources=$(echo "$mergerfs_line" | awk '{print $1}')
    local mergerfs_mount=$(echo "$mergerfs_line" | awk '{print $2}')
    
    local new_sources=$(echo "$mergerfs_sources" | sed "s|:$cloud_mount||g" | sed "s|$cloud_mount:||g" | sed "s|$cloud_mount||g")
    
    if ! sudo sed -i "s|$mergerfs_line|$new_sources $mergerfs_mount fuse.mergerfs defaults,allow_other,use_ino,category.create=mfs,moveonenospc=true 0 0|" /etc/fstab; then
        log_message "Error: Failed to update MergerFS configuration in /etc/fstab."
        return 1
    fi
    
    if ! sudo mount -a; then
        log_message "Error: Failed to remount MergerFS. Please check your configuration and try again."
        return 1
    fi
    
    log_message "Cloud drive successfully removed from MergerFS."
}

# Function to set up automatic mounting
setup_automatic_mounting() {
    log_message "Setting up automatic mounting for cloud drives..."
    
    cat << EOF | sudo tee /etc/systemd/system/rclone-mounts.service > /dev/null
[Unit]
Description=RClone Mounts
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=/bin/bash -c 'mount -a'
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

    if ! sudo systemctl daemon-reload && sudo systemctl enable rclone-mounts.service; then
        log_message "Error: Failed to set up automatic mounting service."
        return 1
    fi
    
    log_message "Automatic mounting service set up successfully."
}

# Function to list mounted cloud drives
list_cloud_drives() {
    log_message "Listing mounted cloud drives:"
    mount | grep rclone | tee -a "$LOG_FILE"
    log_message "Cloud drive entries in /etc/fstab:"
    grep rclone /etc/fstab | tee -a "$LOG_FILE"
}

# Function to check and display the status of cloud drive mounts
check_mount_status() {
    log_message "Checking status of cloud drive mounts..."
    
    local mounts=$(grep rclone /etc/fstab | awk '{print $2}')
    
    for mount in $mounts; do
        if mountpoint -q "$mount"; then
            log_message "$mount is mounted and accessible."
        else
            log_message "$mount is not mounted or inaccessible."
        fi
    done
}

# Main menu
while true; do
    echo "Cloud Drives Setup"
    echo "1. Install rclone"
    echo "2. Update rclone"
    echo "3. Configure Cloud Drive"
    echo "4. Mount Cloud Drive and Integrate with MergerFS"
    echo "5. Unmount Cloud Drive and Remove from MergerFS"
    echo "6. Set Up Automatic Mounting"
    echo "7. List Cloud Drives"
    echo "8. Check Mount Status"
    echo "9. Exit"
    read -p "Enter your choice: " choice

    case $choice in
        1)
            install_rclone
            ;;
        2)
            update_rclone
            ;;
        3)
            configure_cloud_drive
            ;;
        4)
            mount_cloud_drive
            ;;
        5)
            unmount_cloud_drive
            ;;
        6)
            setup_automatic_mounting
            ;;
        7)
            list_cloud_drives
            ;;
        8)
            check_mount_status
            ;;
        9)
            log_message "Exiting Cloud Drives Setup."
            exit 0
            ;;
        *)
            log_message "Invalid choice. Please try again."
            ;;
    esac
    echo
done