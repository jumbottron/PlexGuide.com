#!/bin/bash

##### AppData Path: /pg/appdata/prowlarr
##### Port Number: 9696
##### Time Zone: America/New_York
##### AppData Path: /pg/appdata/prowlarr
##### Version Tag: latest
##### Expose:

# Specify the app name and config file path
deploy_container() {

    # Sourcing App Info - Required
    source /pg/scripts/apps_support.sh "$app_name" && appsourcing

  docker run -d \
    --name="${app_name}" \
    -e PUID=1000 \
    -e PGID=1000 \
    -e TZ="${time_zone}" \
    -p "${expose}""${port_number}":9696 \
    -v "${appdata_path}":/config \
    --restart unless-stopped \
    lscr.io/linuxserver/prowlarr:"${version_tag}"
  
    # display app deployment information
    appverify
}
