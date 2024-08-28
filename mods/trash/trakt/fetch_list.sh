#!/bin/bash

# Load configuration from trakt.cfg
CONFIG_FILE="/pg/config/trakt.cfg"
source "$CONFIG_FILE"

# Define variables
TRAKT_USERNAME="admin9705"  # The username from the URL
LIST_NAME="tv"              # The list name from the URL
SORT_ORDER="rank,asc"       # Sort order as specified

# Function to fetch the list
function fetch_trakt_list() {
    echo "Fetching list: $LIST_NAME from user: $TRAKT_USERNAME..."

    # Send GET request to Trakt API to retrieve list items
    response=$(curl -s -X GET "https://api.trakt.tv/users/$TRAKT_USERNAME/lists/$LIST_NAME/items" \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $TRAKT_ACCESS_TOKEN" \
        -H "trakt-api-version: 2" \
        -H "trakt-api-key: $TRAKT_API_KEY")

    # Check if the response contains items
    if echo "$response" | grep -q "title"; then
        echo "List fetched successfully. Displaying items sorted by $SORT_ORDER:"
        echo "$response" | jq -r '.[] | .type + ": " + .title'
    else
        echo "Failed to fetch list. Check your API token, username, or list name."
        echo "Response: $response"
    fi
}

# Run the function to fetch the list
fetch_trakt_list
