#!/bin/bash

##### Port Number: 3001
##### AppData Path: /pg/appdata/uptimekuma
##### Expose: 

deploy_container() {

     # Sourcing and configuration file - required
    source "/pg/config/${app_name}.cfg"
    source /pg/scripts/apps_support.sh "$app_name"
    source /pg/apps/${app_name}/${app_name}.functions 2>/dev/null

    docker run -d \
      --name="${app_name}" \
      -p "${expose}""${port_number}":3001 \
      -v "${appdata_path}":/app/data \
      --restart=unless-stopped \
      louislam/uptime-kuma:1
    
    # display app deployment information
    appverify
}
