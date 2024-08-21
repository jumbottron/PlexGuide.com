#!/bin/bash

# Function to generate a random 4-digit code
generate_code() {
  echo $((RANDOM % 9000 + 1000))
}

# Function to clear the screen and display the main header
clear_screen() {
  clear
  echo -e "\e[31mPG: Port Security\e[0m"
  echo
}

# Function to prompt for a 4-digit code
prompt_for_code() {
  local correct_code=$(generate_code)
  while true; do
    echo -e "Enter the 4-digit code \e[31m$correct_code\e[0m to proceed or type \e[32m[exit]\e[0m to cancel: "
    read -p "" user_code
    if [[ $user_code == "$correct_code" ]]; then
      break
    elif [[ $user_code == "exit" ]]; then
      exit 0
    else
      echo "Incorrect code. Please try again."
    fi
  done
}

# Function to open a port
open_port() {
  clear_screen
  prompt_for_code
  echo "This is an example placeholder for opening a port until implemented."
  read -p "Press Enter to return to the menu..."
}

# Function to close a port
close_port() {
  clear_screen
  prompt_for_code
  echo "This is an example placeholder for closing a port until implemented."
  read -p "Press Enter to return to the menu..."
}

# Main menu loop
while true; do
  clear_screen
  echo "V) View Open Ports"
  echo "O) Open a Port"
  echo "C) Close a Port"
  echo "Z) Exit"
  echo

  read -p "Choose Select an Option [V/O/C/Z]: " choice

  case "$choice" in
    V|v) bash /pg/scripts/portsecurity_view.sh ;;
    O|o) open_port ;;
    C|c) close_port ;;
    Z|z) exit 0 ;;
    *) echo "Invalid option. Please try again." ;;
  esac
done
