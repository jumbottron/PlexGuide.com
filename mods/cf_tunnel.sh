#!/bin/bash

# Prompt the user for the Cloudflare Tunnel token
read -p "Enter your Cloudflare Tunnel token: " TUNNEL_TOKEN

# Pull the Cloudflare Tunnel Docker image
docker pull cloudflare/cloudflared:latest

# Run the Cloudflare Tunnel Docker container
docker run -d --name=cf_tunnel \
  --restart unless-stopped \
  cloudflare/cloudflared:latest \
  tunnel --no-autoupdate run --token $TUNNEL_TOKEN
