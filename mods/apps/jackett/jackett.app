#!/bin/bash

##### Port Number: 9117
##### Time Zone: America/New_York
##### AppData Path: /pg/appdata/jackett
##### PathTo Blackhole: /pg/downloads/
##### Auto Update: true 
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
      -e AUTO_UPDATE="${auto_update}" \
      -e RUN_OPTS= `#optional` \
      -p "${expose}""${port_number}":9117 \
      -v "${appdata_path}":/config \
      -v "${pathto_blackhole}":/downloads \
      --restart unless-stopped \
      lscr.io/linuxserver/jackett:"${version_tag}"
    
    # display app deployment information
    appverify
}
