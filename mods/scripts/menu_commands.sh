#!/bin/bash

# Function to check and create symbolic links for plexguide and pg commands
check_and_create_commands() {
    
    # List of files to remove
    files=(
        "/usr/local/bin/plexguide"
        "/usr/local/bin/pg"
        "/usr/local/bin/pgalpha"
        "/usr/local/bin/pgbeta"
    )

    # Loop through each file and remove it
    for file in "${files[@]}"; do
        rm -rf "$file"
    done

    # Create PlexGuide Commands
    if [[ ! -f "/usr/local/bin/plexguide" ]]; then
        sudo ln -s /pg/scripts/menu.sh /usr/local/bin/plexguide
        sudo chmod +x /usr/local/bin/plexguide
    fi

    if [[ ! -f "/usr/local/bin/pg" ]]; then
        sudo ln -s /pg/scripts/menu.sh /usr/local/bin/pg
        sudo chmod +x /usr/local/bin/pg
    fi

    if [[ ! -f "/usr/local/bin/pgalpha" ]]; then
        sudo ln -s /pg/scripts/menu_reinstall.sh /usr/local/bin/pgalpha        
        sudo chmod +x /usr/local/bin/pgalpha
        plexguide
    fi

    if [[ ! -f "/usr/local/bin/pgbeta" ]]; then
        sudo ln -s /pg/scripts/menu_reinstall.sh /usr/local/bin/pgalpha        
        sudo chmod +x /usr/local/bin/pgbeta
        plexguide
    fi

    # Apply chmod +x to every file in /pg/scripts/ and /pg/apps/
    sudo chmod +x /pg/scripts/*
    sudo chmod +x /pg/apps/*
}

# Run the check and create commands if necessary
check_and_create_commands
