#!/bin/bash

# Function to view open ports
clear
echo -e "\e[31mPG: Port Security View\e[0m"
echo

# Replace with the actual command to list open ports and sort them numerically
open_ports=$(ss -tuln | grep LISTEN | awk '{print $5}' | cut -d: -f2 | sort -n | tr '\n' ',' | sed 's/,$//')

# Wrap open ports to fit within an 80-character width
width=80
current_line=""
for port in ${open_ports//,/ }; do
  if [ ${#current_line} -eq 0 ]; then
    current_line="$port"
  elif [ $((${#current_line} + ${#port} + 1)) -lt $width ]; then
    current_line+=", $port"
  else
    echo "$current_line"
    current_line="$port"
  fi
done
[ -n "$current_line" ] && echo "$current_line"

echo
read -p "Press [Enter] to exit the view." dummy
