#!/bin/bash

app_name=$1

# Function: stop_and_remove_app
stop_and_remove_app() {
    docker ps --filter "name=^/${app_name}$" --format "{{.Names}}" &> /dev/null
    if [[ $? -eq 0 ]]; then
        echo "Stopping and removing the existing container for $app_name ..."
        docker stop "$app_name" && docker rm "$app_name"
    else
        echo "Container $app_name is not running."
    fi
}

# Run the stop and remove function
stop_and_remove_app
