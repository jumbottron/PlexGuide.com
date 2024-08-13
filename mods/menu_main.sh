#!/bin/bash

# Clear the screen at the start
clear

# Welcome message
echo "Welcome to PlexGuide: 11.0"
echo ""  # Blank line for separation

# Start of the menu loop
while true; do
  # Display the menu options
  echo "Please select an option:"
  echo "1) Test A"
  echo "2) Test B"
  echo "3) Test C"
  echo "4) Test D"
  echo "5) Exit"
  echo ""  # Space between options and input prompt

  # Prompt the user for input
  read -p "Enter your choice [1-5]: " choice

  case $choice in
    1)
      clear
      echo "You selected Test A"
      ;;
    2)
      clear
      echo "You selected Test B"
      ;;
    3)
      clear
      echo "You selected Test C"
      ;;
    4)
      clear
      echo "You selected Test D"
      ;;
    5)
      clear
      echo "Thank You for using PlexGuide"
      exit 0
      ;;
    *)
      echo "Invalid option, please try again."
      ;;
  esac

  # Prompt the user to press Enter to continue
  read -p "Press Enter to continue..."

  # Clear the screen
  clear
done
