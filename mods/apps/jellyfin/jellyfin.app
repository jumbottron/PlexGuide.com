#!/bin/bash

##### Port Number: 8095
##### Time Zone: America/New_York
##### AppData Path: /pg/appdata/jellyfin
##### Movies Path: /pg/media/movies
##### TV Path: /pg/media/tv
##### JF ServerUrl: 1.1.1.1
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
      -e JELLYFIN_PublishedServerUrl="${jf_serverurl}" \
      -p "${expose}""${port_number}":8096 \
      -v "${appdata_path}":/config \
      -v "${tv_path}":/data/tvshows \
      -v "${movies_path}":/data/movies \
      --restart unless-stopped \
      lscr.io/linuxserver/jellyfin:"${version_tag}"

    # display app deployment information
    appverify
}
