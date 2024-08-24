#!/bin/bash

##### Port Number: 7878
##### Time Zone: America/New_York
##### AppData Path: /pg/appdata/radarr
##### Movies Path: /pg/media/movies
##### ClientDownload Path: /pg/downloads
##### Version Tag: latest
##### Expose:

deploy_container() {

    # Sourcing App Info - Required
    source /pg/scripts/apps_support.sh "$app_name" && appsourcing

    docker run -d \
      --name="${app_name}" \
      -e PUID=1000 \
      -e PGID=1000 \
      -e TZ="${time_zone}" \
      -p "${expose}""${port_number}":7878 \
      -v "${appdata_path}":/config \
      -v "${movies_path}":/movies \
      -v "${clientdownload_path}":/downloads \
      --restart unless-stopped \
      lscr.io/linuxserver/radarr:"${version_tag}"
    
    # display app deployment information
    appverify
}
