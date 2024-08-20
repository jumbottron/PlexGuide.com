#!/bin/bash

# Display the menu
clear
echo "PG: GPU Driver Management"
echo
echo "I) Intel"
echo "N) NVIDIA"
echo "Z) Exit"
echo

# Prompt the user for input
read -p "Select a letter [A/I/Z]: " user_choice

# Handle user input
case "$user_choice" in
    I|i)
        echo "Redirecting to Intel driver management..."
        /pg/scripts/intel.sh
        ;;
    N|n)
        echo "Redirecting to Nvidia driver management..."
        /pg/scripts/nvidia.sh
        ;;
    Z|z)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid choice. Please try again."
        ;;
esac
