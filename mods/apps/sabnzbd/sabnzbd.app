#!/bin/bash

##### Port Number: 9000
##### Time Zone: America/New_York
##### AppData Path: /pg/appdata/sabnzbd
##### Download Path: /pg/downloads/nzbget/downloads/
##### Incomplete Downloads: /pg/downloads/nzbget/incomplete_downloads
##### Version Tag: latest
##### Expose:

deploy_container() {

    # Sourcing and configuration file - required
    source "/pg/config/${app_name}.cfg"
    source /pg/scripts/apps_support.sh "$app_name"
    source /pg/apps/${app_name}/${app_name}.functions

    docker run -d \
      --name="${app_name}" \
      -e PUID=1000 \
      -e PGID=1000 \
      -e TZ="${time_zone}" \
      -p "${expose}""${port_number}":8080 \
      -v "${appdata_path}":/config \
      -v "${download_path}":/downloads \
      -v "${incomplete_downloads}":/incomplete-downloads \
      --restart unless-stopped \
      lscr.io/linuxserver/sabnzbd:"${version_tag}"
    
    # display app deployment information
    appverify
}
