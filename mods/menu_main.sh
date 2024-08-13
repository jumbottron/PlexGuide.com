#!/bin/bash

# Clear the screen at the start
clear

# Function for the Test A submenu
test_a_submenu() {
  while true; do
    clear
    echo "Welcome to Docker Management - Test A"
    echo ""  # Blank line for separation
    echo "Please select an option:"
    echo "1) Test A1"
    echo "2) Test A2"
    echo "3) Test A3"
    echo "4) Test A4"
    echo "5) Exit"
    echo ""  # Space between options and input prompt

    read -p "Enter your choice [1-5]: " sub_choice

    case $sub_choice in
      1)
        clear
        echo "Executed Test A1"
        ;;
      2)
        clear
        echo "Executed Test A2"
        ;;
      3)
        clear
        echo "Executed Test A3"
        ;;
      4)
        clear
        echo "Executed Test A4"
        ;;
      5)
        clear
        break  # Exit the submenu and return to the main menu
        ;;
      *)
        echo "Invalid option, please try again."
        ;;
    esac

    # Prompt the user to press Enter to continue
    read -p "Press Enter to continue..."
  done
}

# Function for the Test B submenu
test_b_submenu() {
  while true; do
    clear
    echo "Welcome to Docker Management - Test B"
    echo ""  # Blank line for separation
    echo "Please select an option:"
    echo "1) Test B1"
    echo "2) Test B2"
    echo "3) Test B3"
    echo "4) Test B4"
    echo "5) Exit"
    echo ""  # Space between options and input prompt

    read -p "Enter your choice [1-5]: " sub_choice

    case $sub_choice in
      1)
        clear
        echo "Executed Test B1"
        ;;
      2)
        clear
        echo "Executed Test B2"
        ;;
      3)
        clear
        echo "Executed Test B3"
        ;;
      4)
        clear
        echo "Executed Test B4"
        ;;
      5)
        clear
        break  # Exit the submenu and return to the main menu
        ;;
      *)
        echo "Invalid option, please try again."
        ;;
    esac

    # Prompt the user to press Enter to continue
    read -p "Press Enter to continue..."
  done
}

# Function for the Test C submenu
test_c_submenu() {
  while true; do
    clear
    echo "Welcome to Docker Management - Test C"
    echo ""  # Blank line for separation
    echo "Please select an option:"
    echo "1) Test C1"
    echo "2) Test C2"
    echo "3) Test C3"
    echo "4) Test C4"
    echo "5) Exit"
    echo ""  # Space between options and input prompt

    read -p "Enter your choice [1-5]: " sub_choice

    case $sub_choice in
      1)
        clear
        echo "Executed Test C1"
        ;;
      2)
        clear
        echo "Executed Test C2"
        ;;
      3)
        clear
        echo "Executed Test C3"
        ;;
      4)
        clear
        echo "Executed Test C4"
        ;;
      5)
        clear
        break  # Exit the submenu and return to the main menu
        ;;
      *)
        echo "Invalid option, please try again."
        ;;
    esac

    # Prompt the user to press Enter to continue...
    read -p "Press Enter to continue..."
  done
}

# Function for the Test D submenu
test_d_submenu() {
  while true; do
    clear
    echo "Welcome to Docker Management - Test D"
    echo ""  # Blank line for separation
    echo "Please select an option:"
    echo "1) Test D1"
    echo "2) Test D2"
    echo "3) Test D3"
    echo "4) Test D4"
    echo "5) Exit"
    echo ""  # Space between options and input prompt

    read -p "Enter your choice [1-5]: " sub_choice

    case $sub_choice in
      1)
        clear
        echo "Executed Test D1"
        ;;
      2)
        clear
        echo "Executed Test D2"
        ;;
      3)
        clear
        echo "Executed Test D3"
        ;;
      4)
        clear
        echo "Executed Test D4"
        ;;
      5)
        clear
        break  # Exit the submenu and return to the main menu
        ;;
      *)
        echo "Invalid option, please try again."
        ;;
    esac

    # Prompt the user to press Enter to continue
    read -p "Press Enter to continue..."
  done
}

# Function for the main menu
main_menu() {
  while true; do
    clear
    echo "Welcome to PlexGuide: 11.0"
    echo ""  # Blank line for separation
    # Display the main menu options
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
        test_a_submenu  # Call the Test A submenu function
        ;;
      2)
        test_b_submenu  # Call the Test B submenu function
        ;;
      3)
        test_c_submenu  # Call the Test C submenu function
        ;;
      4)
        test_d_submenu  # Call the Test D submenu function
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
  done
}

# Call the main menu function
main_menu
