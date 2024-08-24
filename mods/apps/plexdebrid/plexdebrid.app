#!/bin/bash

##### AppData Path: /pg/appdata/plex_debrid
##### Port Number: 32400
##### Time Zone: America/New_York
##### Version Tag: latest
##### Expose:

deploy_container() {

    # Sourcing App Info - Required
    source /pg/scripts/apps_support.sh "$app_name" && appsourcing

    # Run the Docker container with the specified settings
    docker run -d \
      --name="${app_name}" \
      --network=host \
      -v "${config_path}:/config" \
      --restart unless-stopped \
      itstoggle/plex_debrid:"${version_tag}"
    
    # display app deployment information
    appverify
}
