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
    config_path="/pg/config/${app_name}.cfg"
    source /pg/scripts/apps_support.sh "$app_name"
    source "$config_path"

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
