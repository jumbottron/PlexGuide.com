#!/bin/bash

deploy_container() {

    # Sourcing App Info - Required
    source /pg/scripts/apps_support.sh "$app_name" && appsourcing

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
