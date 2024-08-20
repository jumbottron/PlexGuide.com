#!/bin/bash

# Display the menu
clear
echo "PG: GPU Driver Management"
echo
echo "A) AMD"
echo "I) Intel"
echo "N) NVIDIA"
echo

# Prompt the user for input
read -p "Select a letter (A, I, N) or type 'exit' to quit: " user_choice

# Handle user input
case "$user_choice" in
    A|a)
        echo "Option A) AMD will be updated. Press Enter to acknowledge."
        read -p ""
        ;;
    I|i)
        echo "Redirecting to Intel driver management..."
        /pg/scripts/intel.sh
        ;;
    N|n)
        echo "Option N) NVIDIA will be updated. Press Enter to acknowledge."
        read -p ""
        ;;
    exit|EXIT|Exit)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid choice. Please try again."
        ;;
esac
