#!/bin/bash

# Function to verify if the Docker container is running
appsourcing() {
     source "/pg/config/${app_name}.cfg"
    source /pg/apps/${app_name}/${app_name}.functions 2>/dev/null
}

# Function to verify if the Docker container is running
appverify() {
    local app_name="$1"
    docker ps | grep "$app_name"
}
 
# Function to source configuration from the config file
configsource() {
    local app_name="$1"
    config_path="/pg/config/${app_name}.cfg"
    if [ -f "$config_path" ]; then
        source "$config_path"
    else
        echo "Config file for ${app_name} not found at ${config_path}."
        exit 1
    fi
}
