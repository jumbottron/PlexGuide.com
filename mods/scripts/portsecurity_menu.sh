#!/bin/bash

# Define colors
RED='\e[31m'
GREEN='\e[32m'
NC='\e[0m' # No Color

# Function to clear the screen and display the main header
clear_screen() {
  clear
  echo -e "${RED}PG: Firewall Port Security${NC}"
  echo
}

# Main menu loop
while true; do
  clear_screen
  echo "V) View Open Ports"
  echo "O) Open a Port"
  echo "C) Close a Port"
  echo "Z) Exit"
  echo

  read -p "Choose an option: " choice

  case "$choice" in
    V|v) bash /pg/scripts/portsecurity_view.sh ;;
    O|o) bash /pg/scripts/portsecurity_open.sh ;;
    C|c) bash /pg/scripts/portsecurity_closed.sh ;;
    Z|z) exit 0 ;;
    *) echo "Invalid option. Please try again." ;;
  esac
done
