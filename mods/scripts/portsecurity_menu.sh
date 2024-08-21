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
    read -p "Enter the 4-digit code to proceed or type 'exit' to cancel: " user_code
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
  read -p "Enter the port number to open: " port_number
  # Replace the following line with the actual command to open a port
  echo "Opening port $port_number..."
  # Example: sudo ufw allow $port_number
  echo "Port $port_number has been opened."
  read -p "Press Enter to return to the menu..."
}

# Function to close a port
close_port() {
  clear_screen
  prompt_for_code
  read -p "Enter the port number to close: " port_number
  # Replace the following line with the actual command to close a port
  echo "Closing port $port_number..."
  # Example: sudo ufw deny $port_number
  echo "Port $port_number has been closed."
  read -p "Press Enter to return to the menu..."
}

# Main menu loop
while true; do
  clear_screen
  echo -e "\e[31mV) View Open Ports\e[0m"
  echo -e "\e[31mO) Open a Port\e[0m"
  echo -e "\e[31mC) Close a Port\e[0m"
  echo -e "\e[31mZ) Exit\e[0m"
  echo

  read -p "Choose an option: " choice

  case "$choice" in
    V|v) bash ./portsecurity_view.sh ;;
    O|o) open_port ;;
    C|c) close_port ;;
    Z|z) exit 0 ;;
    *) echo "Invalid option. Please try again." ;;
  esac
done
