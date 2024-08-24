#!/bin/bash

##### Port Number: 8081
##### Time Zone: America/New_York
##### AppData Path: /pg/appdata/sickgear
##### TV Path: /pg/media/tv
##### Download Path: /pg/downloads
##### Version Tag: latest
##### Expose:

deploy_container() {

    # Sourcing and configuration file - required
    source "/pg/config/${app_name}.cfg"
    source /pg/scripts/apps_support.sh "$app_name"
    source /pg/apps/${app_name}/${app_name}.functions 2>/dev/null
 
    docker run -d \
      --name="${app_name}" \
      -e PUID=1000 \
      -e PGID=1000 \
      -e TZ="${time_zone}" \
      -p "${expose}""${port_number}":8081 \
      -v "${appdata_path}":/config \
      -v "${tv_path}":/tv \
      -v "${download_path}":/downloads \
      --restart unless-stopped \
      lscr.io/linuxserver/sickgear:"${version_tag}"
    
    # display app deployment information
    appverify
}
