#!/bin/bash

##### Port Number: 5055
##### Time Zone: America/New_York
##### AppData Path: /pg/appdata/overseerr
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
      -p "${expose}""${port_number}":5055 \
      -v "${appdata_path}":/config \
      --restart unless-stopped \
      lscr.io/linuxserver/overseerr:"${version_tag}"
    
    # display app deployment information
    appverify
}
