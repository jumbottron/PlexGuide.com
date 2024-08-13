#!/bin/bash

# Prompt the user for the Plex claim key
read -p "Enter your Plex claim key: " CLAIM_KEY

# Set the default Docker image version, appdata location, and timezone
DOCKER_VERSION=${1:-"latest"}
APPDATA_LOCATION=${2:-"/pg/appdata/plex"}
TIMEZONE=${3:-"America/New_York"}

# Ensure the media directory exists
MEDIA_PATH="/pg/media"
mkdir -p $MEDIA_PATH

# Pull the specified version of the Plex Docker image
docker pull plexinc/pms-docker:$DOCKER_VERSION

# Run the Plex Docker container with the specified settings
docker run -d \
  --name=plex \
  --network=host \
  -e PLEX_CLAIM=$CLAIM_KEY \
  -e TZ=$TIMEZONE \
  -v $APPDATA_LOCATION:/config \
  -v $MEDIA_PATH:/media \
  -v /etc/localtime:/etc/localtime:ro \
  --restart unless-stopped \
  plexinc/pms-docker:$DOCKER_VERSION

# Verify the Docker container is running
docker ps | grep plex
