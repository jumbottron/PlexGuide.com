#!/bin/bash

# Update the package index
sudo apt-get update

# Install OpenSSH server if not already installed
sudo apt-get install -y openssh-server

# Backup the current SSH configuration file
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

# Change SSH port to 2222
sudo sed -i 's/#Port 22/Port 2222/' /etc/ssh/sshd_config

# Allow the new port through the firewall
sudo ufw allow 2222/tcp

# Reload the SSH service to apply changes
sudo systemctl reload sshd

# Enable SSH service to start on boot
sudo systemctl enable ssh

# Restart SSH service
sudo systemctl restart ssh

# Display the status of the SSH service
sudo systemctl status ssh --no-pager
