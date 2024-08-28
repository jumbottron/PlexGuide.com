#!/bin/bash

# Define the path to the config file
CONFIG_FILE="/pg/config/trakt.cfg"

# Function to create or read the config file
function check_config_file() {
    # If the config file doesn't exist, create it
    if [ ! -f "$CONFIG_FILE" ]; then
        echo "Creating configuration file: $CONFIG_FILE"
        echo "TRAKT_API_KEY=\"\"" > "$CONFIG_FILE"
        echo "TRAKT_API_SECRET=\"\"" >> "$CONFIG_FILE"
        echo "TRAKT_ACCESS_TOKEN=\"\"" >> "$CONFIG_FILE"
    fi

    # Source the config file to read existing variables
    source "$CONFIG_FILE"

    # Prompt user for missing values
    if [ -z "$TRAKT_API_KEY" ]; then
        read -p "Enter your Trakt API Key: " TRAKT_API_KEY
        echo "TRAKT_API_KEY=\"$TRAKT_API_KEY\"" >> "$CONFIG_FILE"
    fi

    if [ -z "$TRAKT_API_SECRET" ]; then
        read -p "Enter your Trakt API Secret: " TRAKT_API_SECRET
        echo "TRAKT_API_SECRET=\"$TRAKT_API_SECRET\"" >> "$CONFIG_FILE"
    fi

    if [ -z "$TRAKT_ACCESS_TOKEN" ]; then
        read -p "Enter your Trakt Access Token (leave empty to generate new): " TRAKT_ACCESS_TOKEN
        if [ -z "$TRAKT_ACCESS_TOKEN" ]; then
            authenticate_trakt
        else
            echo "TRAKT_ACCESS_TOKEN=\"$TRAKT_ACCESS_TOKEN\"" >> "$CONFIG_FILE"
        fi
    fi
}

# Function to authenticate with Trakt and generate access token
function authenticate_trakt() {
    echo "Authenticating with Trakt..."

    # Request a device code
    response=$(curl -s -X POST "https://api.trakt.tv/oauth/device/code" \
        -H "Content-Type: application/json" \
        -d "{\"client_id\":\"$TRAKT_API_KEY\"}")

    device_code=$(echo "$response" | jq -r .device_code)
    user_code=$(echo "$response" | jq -r .user_code)

    echo "Please go to https://trakt.tv/activate and enter the code: $user_code"
    echo "Waiting for authentication to complete..."

    # Poll to check if the user has completed authentication
    while true; do
        auth_response=$(curl -s -X POST "https://api.trakt.tv/oauth/device/token" \
            -H "Content-Type: application/json" \
            -d "{\"code\":\"$device_code\", \"client_id\":\"$TRAKT_API_KEY\", \"client_secret\":\"$TRAKT_API_SECRET\"}")

        access_token=$(echo "$auth_response" | jq -r .access_token)
        if [ "$access_token" != "null" ]; then
            echo "Authentication successful!"
            echo "TRAKT_ACCESS_TOKEN=\"$access_token\"" >> "$CONFIG_FILE"
            break
        else
            echo "Waiting for user to authorize... (check the URL: https://trakt.tv/activate)"
            sleep 5
        fi
    done
}

# Main function to check config and authenticate
function main() {
    check_config_file

    # Verify if the stored access token is valid by making an API request
    verify_response=$(curl -s -X GET "https://api.trakt.tv/users/me" \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $TRAKT_ACCESS_TOKEN" \
        -H "trakt-api-version: 2" \
        -H "trakt-api-key: $TRAKT_API_KEY")

    if echo "$verify_response" | grep -q "\"username\""; then
        echo "Access token verified. You are successfully authenticated!"
    else
        echo "Failed to verify the access token. Initiating new authentication."
        authenticate_trakt
    fi
}

# Run the main function
main
