#!/bin/bash

# ANSI color codes
RED="\033[0;31m"
NC="\033[0m" # No color

# Clear the screen at the start
clear

# Display information and commands
echo "Visit github.com/plexguide/PlexGuide.com or plexguide.com"
echo ""  # Space for separation
echo "Commands:"
echo -e "[1] plexguide   |  Deploy PlexGuide"
echo -e "[2] pg          |  Deploy PlexGuide"
echo -e "[3] pgalpha     |  Install Latest Alpha Build"
echo -e "[4] pgbeta      |  Install Latest Beta Build"  # New command for Beta Build
echo ""  # Space before exiting

# Exit the script
exit 0
