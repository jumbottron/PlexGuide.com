#!/bin/bash

##### Port Number: 4748
##### AppData Path: /pg/appdata/vaultwarden
##### Signups Enabled: false
##### WebSocket Enabled: false
##### Admin Token: null
##### Version Tag: latest
##### Expose: 

# ANSI color codes
RED="\033[0;31m"
GREEN="\033[0;32m"
NC="\033[0m" # No color

# Function to deploy the Docker container for Vaultwarden
deploy_container() {

    # Sourcing App Info - Required
    source /pg/scripts/apps_support.sh "$app_name" && appsourcing

    # Creates admin token if one does not exist
    check_and_update_vaultwarden_token

    # Run the Vaultwarden Docker container with the specified settings
    docker run -d \
      --name="${app_name}" \
      -e SIGNUPS_ALLOWED="${signups_allowed}" \
      -e WEBSOCKET_ENABLED="${websocket_enabled}" \
      -e ADMIN_TOKEN="${admin_token}" \
      -p "${expose}""${port_number}":80/tcp \
      -v "${appdata_path}:/data:rw" \
      --restart unless-stopped \
      vaultwarden/server:"${version_tag}"

    # display app deployment information
    appverify
}
