#!/bin/bash

# Function: check_expose_status
check_expose_status() {
    local app_name=$1
    local config_path="/pg/config/${app_name}.cfg"

    # Default status
    local expose_status="Unknown"

    # Source the config to get the current expose setting
    if [[ -f "$config_path" ]]; then
        source "$config_path"
        
        # Determine expose status
        if [[ "$expose" == "127.0.0.1:" ]]; then
            expose_status="No - Closed/Internal"
        elif [[ "$expose" == "" ]]; then
            expose_status="Yes - Remote Accessible"
        fi
    else
        echo "Error: Configuration file for $app_name not found."
        exit 1
    fi

    # Return the status
    echo "$expose_status"
}
