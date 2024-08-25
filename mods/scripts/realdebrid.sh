#!/bin/bash

# Step 1: Create necessary directories
echo "Creating directories for Rclone configuration and cache..."
sudo mkdir -p ~/rclone/config
sudo mkdir -p ~/rclone/cache

# Step 2: Prompt the user for the Real-Debrid API key
read -p "Enter your Real-Debrid API key: " API_KEY

# Step 3: Install the Rclone Docker plugin
echo "Installing the Rclone Docker plugin..."
sudo docker plugin install itstoggle/docker-volume-rclone_rd:amd64 args="-v" --alias rclone --grant-all-permissions config=~/rclone/config cache=~/rclone/cache

# Step 4: Create the Real-Debrid Docker volume using the provided API key
echo "Creating Real-Debrid Docker volume..."
sudo docker volume create realdebrid -d rclone -o type=realdebrid -o realdebrid-api_key="$API_KEY" -o allow-other=true -o dir-cache-time=10s

# Step 5: Verify the volume creation
echo "Verifying the Real-Debrid Docker volume..."
sudo docker run --rm -i -v=realdebrid:/tmp/myvolume busybox find /tmp/myvolume

echo -e "\nReal-Debrid Docker volume setup completed. You can now mount this volume into any Docker container."
