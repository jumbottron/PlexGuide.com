#!/bin/bash

##### Port Number: 4700
##### Port Two: 4699
##### AppData Path: /pg/appdata/firefox
##### Version Tag: latest
##### Time Zone: America/New_York
##### FirefoxCLI URL: https://www.linuxserver.io
##### Shm Size: 1gb
##### Expose:

deploy_container() {

    # Sourcing and configuration file - required
    config_path="/pg/config/${app_name}.cfg"
    source /pg/scripts/apps_support.sh "$app_name"
    source "$config_path"

    docker run -d \
      --name="${app_name}" \
      --security-opt seccomp=unconfined \
      -e PUID=1000 \
      -e PGID=1000 \
      -e TZ="${time_zone}" \
      -e FIREFOX_CLI="${firefoxcli_url}" \
      -p "${expose}""${port_number}":3000 \
      -p "${expose}""${port_two}":3001 \
      -v "${appdata_path}":/config \
      --shm-size="${shm_size}" \
      --restart unless-stopped \
      lscr.io/linuxserver/firefox:"${version_tag}"
    
    # display app deployment information
    appverify
}
