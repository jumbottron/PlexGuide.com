#!/bin/bash

##### Media Path: /pg/media
##### Port Number: 32400
##### Time Zone: America/New_York
##### AppData Path: /pg/appdata/plex
##### Plex Token: null
##### Version Tag: latest
##### Expose:

# ANSI color codes
RED="\033[0;31m"
GREEN="\033[0;32m"
NC="\033[0m" # No color

# Function to deploy the Docker container for the app
deploy_container() {

    # Sourcing App Info - Required
    source /pg/scripts/apps_support.sh "$app_name" && appsourcing

    # If no token exists, prompts user to create one for the claim
    check_plex_token_default

    # Run the Plex Docker container with the specified settings
    docker run -d \
      --name="${app_name}" \
      --net=host \
      -e PUID=1000 \
      -e PGID=1000 \
      -e TZ="${time_zone}" \
      -e VERSION=docker \
      -e PLEX_CLAIM="${plex_token}" \
      -v "${appdata_path}":/config \
      -v "${media_path}":/media \
      -v realdebrid:/torrents \
      --restart unless-stopped \
      lscr.io/linuxserver/plex:"${version_tag}"

    # display app deployment information
    appverify
}
