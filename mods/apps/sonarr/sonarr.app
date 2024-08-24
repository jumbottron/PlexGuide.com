#!/bin/bash

##### Port Number: 8989
##### Time Zone: America/New_York
##### AppData Path: /pg/appdata/sonarr
##### Movies Path: /pg/media/tv
##### ClientDownload Path: /pg/downloads
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
      -p "${expose}""${port_number}":8989 \
      -v "${appdata_path}":/config \
      -v "${movies_path}":/movies \
      -v "${clientdownload_path}":/downloads \
      --restart unless-stopped \
      lscr.io/linuxserver/sonarr:"${version_tag}"
    
    # display app deployment information
    appverify
}
