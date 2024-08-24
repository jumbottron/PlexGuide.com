#!/bin/bash

# ANSI color codes
RED="\033[0;31m"
GREEN="\033[0;32m"
PURPLE="\033[0;35m"
CYAN="\033[0;36m"
NC="\033[0m" # No color

prepare_tmp_directory() {
    local tmp_dir="/pg/tmp"
    
    # Create the /pg/tmp directory if it doesn't exist
    if [[ ! -d "$tmp_dir" ]]; then
        mkdir -p "$tmp_dir"
    fi
    
    # Set ownership to user with UID and GID 1000
    chown -R 1000:1000 "$tmp_dir"
    
    # Set the directory as executable
    chmod -R +x "$tmp_dir"
}

# Function to display the interface
display_interface() {
    clear
    echo -e "${CYAN}PG Edition Selection Interface${NC}"
    echo -e "Note: Stable Edition will be Released When Ready."
    echo ""  # Space below the note
    echo -e "[${RED}A${NC}] PG Alpha"
    echo -e "[${PURPLE}B${NC}] PG Beta"
    echo ""
}

# Function to validate the user's choice
validate_choice() {
    local choice="$1"
    case ${choice,,} in
        a)
            echo ""
            echo "Selected PG Alpha."
            run_install_script "https://raw.githubusercontent.com/plexguide/PlexGuide.com/v11/mods/scripts/install_alpha.sh"
            ;;
        b)
            echo ""
            echo "Selected PG Beta."
            run_install_script "https://raw.githubusercontent.com/plexguide/PlexGuide.com/v11/mods/scripts/install_beta.sh"
            ;;
        z)
            echo "Exiting the selection interface."
            exit 0
            ;;
        *)
            # Instead of clearing and re-displaying the interface, we call it again
            echo "Invalid input. Please try again."
            ;;
    esac
}

# Function to download and run the selected installation script
run_install_script() {
    local script_url="$1"
    local tmp_dir="/pg/tmp"
    local script_file="$tmp_dir/install_script.sh"
    local random_pin=$(printf "%04d" $((RANDOM % 10000)))

    # Prepare the /pg/tmp directory
    prepare_tmp_directory

    while true; do
        read -p "$(echo -e "Type [${RED}${random_pin}${NC}] to proceed or [${GREEN}Z${NC}] to cancel: ")" response
        if [[ "$response" == "$random_pin" ]]; then
            echo "Downloading the installation script..."
            curl -sL "$script_url" -o "$script_file"
            
            # Check if the script was downloaded successfully
            if [[ -f "$script_file" ]]; then
                rm -rf /pg/scripts/* /pg/apps/* 2>/dev/null
                echo "Executing the installation script..."
                bash "$script_file"
                
                # Set correct permissions after script execution
                chown -R 1000:1000 /pg/scripts /pg/apps
                chmod -R +x /pg/scripts /pg/apps
                
                # Make sure 'plexguide' and other commands have the correct permissions
                ln -sf /pg/scripts/menu.sh /usr/local/bin/plexguide
                ln -sf /pg/scripts/menu.sh /usr/local/bin/pg
                ln -sf /pg/scripts/menu.sh /usr/local/bin/pgalpha
                chmod +x /usr/local/bin/plexguide /usr/local/bin/pg /usr/local/bin/pgalpha

                # Run plexguide automatically after the installation
                echo "Starting PlexGuide..."
                exec plexguide
                exit 0
            else
                echo "Failed to download the installation script. Please check your internet connection and try again."
                exit 1
            fi
        elif [[ "${response,,}" == "z" ]]; then
            echo "Installation canceled."
            exit 0
        else
            echo "Invalid input. Please try again."
        fi
    done
}

# Main loop to display the interface and handle user input
while true; do
    display_interface
    read -p "Enter your choice: " user_choice
    validate_choice "$user_choice"
    
    # Direct exit if 'z' or 'Z' is chosen
    if [[ "${user_choice,,}" == "z" ]]; then
        exit 0
    fi
done
