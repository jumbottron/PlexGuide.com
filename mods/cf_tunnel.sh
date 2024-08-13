#!/bin/bash

# Prompt the user for the Cloudflare token tunnel
read -p "Please enter your Cloudflare token tunnel: " CF_TUNNEL_TOKEN

# Check if the token is not empty
if [ -z "$CF_TUNNEL_TOKEN" ]; then
  echo "Error: Cloudflare token tunnel cannot be empty."
  exit 1
fi

# Create the Docker container with the provided token
docker run -d \
  --name cloudflare-tunnel \
  -e TUNNEL_TOKEN="$CF_TUNNEL_TOKEN" \
  cloudflare/cloudflared:latest

# Confirm that the container has been created
if [ $? -eq 0 ]; then
  echo "Cloudflare Tunnel Docker container created successfully."
else
  echo "Failed to create the Cloudflare Tunnel Docker container."
fi
