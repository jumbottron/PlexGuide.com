#!/bin/bash

CONFIG_FILE="personal_apps_config.json"

# Function to add a personal repo
add_personal_repo() {
    local repo_url="$1"
    if [ ! -f "$CONFIG_FILE" ]; then
        echo '{"repos": []}' > "$CONFIG_FILE"
    fi
    
    if ! grep -q "$repo_url" "$CONFIG_FILE"; then
        tmp=$(mktemp)
        jq ".repos += [\"$repo_url\"]" "$CONFIG_FILE" > "$tmp" && mv "$tmp" "$CONFIG_FILE"
        echo "Added personal repo: $repo_url"
    else
        echo "Repo $repo_url already exists."
    fi
}

# Function to list personal apps
list_personal_apps() {
    if [ ! -f "$CONFIG_FILE" ]; then
        echo "No personal repos added yet."
        return
    fi

    repos=$(jq -r '.repos[]' "$CONFIG_FILE")
    for repo in $repos; do
        echo "Apps available in $repo:"
        curl -s "$repo/apps.json" | jq -r '.[] | "- \(.name): \(.description)"'
    done
}

# Function to deploy a personal app
deploy_personal_app() {
    local app_name="$1"
    if [ ! -f "$CONFIG_FILE" ]; then
        echo "No personal repos added yet."
        return
    fi

    repos=$(jq -r '.repos[]' "$CONFIG_FILE")
    for repo in $repos; do
        app_info=$(curl -s "$repo/apps.json" | jq -r ".[] | select(.name == \"$app_name\")")
        if [ ! -z "$app_info" ]; then
            echo "Deploying $app_name..."
            image=$(echo "$app_info" | jq -r '.image')
            ports=$(echo "$app_info" | jq -r '.ports | join(" -p ")')
            docker run -d --name "$app_name" -p $ports "$image"
            echo "$app_name deployed successfully!"
            return
        fi
    done
    
    echo "App $app_name not found in any personal repo."
}

# Main menu
while true; do
    echo "Personal Apps Manager"
    echo "1. Add Personal Repo"
    echo "2. List Personal Apps"
    echo "3. Deploy Personal App"
    echo "4. Exit"
    read -p "Enter your choice: " choice

    case $choice in
        1)
            read -p "Enter repo URL: " repo_url
            add_personal_repo "$repo_url"
            ;;
        2)
            list_personal_apps
            ;;
        3)
            read -p "Enter app name to deploy: " app_name
            deploy_personal_app "$app_name"
            ;;
        4)
            echo "Exiting Personal Apps Manager."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please try again."
            ;;
    esac
    echo
done