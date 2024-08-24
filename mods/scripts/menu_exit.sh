#!/bin/bash

# ANSI color codes
RED="\033[0;31m"
ORANGE="\033[0;33m"
PURPLE="\033[0;35m"
NC="\033[0m" # No color

# Clear the screen at the start
clear

# Display information and commands
echo "Visit github.com/plexguide/PlexGuide.com or plexguide.com"
echo ""  # Space for separation
echo "Commands:"
echo -e "[${ORANGE}1${NC}] plexguide   |  Deploy PlexGuide"
echo -e "[${ORANGE}2${NC}] pg          |  Deploy PlexGuide"
echo -e "[${RED}3${NC}] pgalpha     |  Install Latest Alpha Build"
echo -e "[${PURPLE}4${NC}] pgbeta      |  Install Latest Beta Build"  # New command for Beta Build
echo ""  # Space before exiting

# Exit the script
exit 0
