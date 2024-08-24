#!/bin/bash

##### Port Number: 8265
##### Port Two: 8266
##### Time Zone: America/New_York
##### AppData Path: /pg/appdata/tdarr_server
##### Media Path: /pg/media
##### Transcode Cache Path: /pg/transcode
##### Node Name: InternalNode
##### FFMPEG Version: 6
##### Version Tag: latest

deploy_container() {
    
    # Sourcing App Info - Required
    source /pg/scripts/apps_support.sh "$app_name" && appsourcing
    
    docker run -ti \
        --name="tdarr_server" \
        -v "${appdata_path}/server":/app/server \
        -v "${appdata_path}/configs":/app/configs \
        -v "${appdata_path}/logs":/app/logs \
        -v "${media_path}":/media \
        -v "${transcode_cache_path}":/temp \
        -e "serverIP=0.0.0.0" \
        -e "serverPort=${port_number}" \
        -e "webUIPort="${expose}""${port_number}"" \
        -e "internalNode=true" \
        -e "inContainer=true" \
        -e "ffmpegVersion=${ffmpeg_version}" \
        -e "nodeName=${node_name}" \
        --network bridge \
        -p "${expose}""${port_number}":8265 \
        -p "${expose}""${port_two}":8266 \
        -e "TZ=${time_zone}" \
        -e PUID=1000 \
        -e PGID=1000 \
        -e "NVIDIA_DRIVER_CAPABILITIES=all" \
        -e "NVIDIA_VISIBLE_DEVICES=all" \
        --gpus=all \
        --device=/dev/dri:/dev/dri \
        --log-opt max-size=10m \
        --log-opt max-file=5 \
        ghcr.io/haveagitgat/tdarr:"${version_tag}"

    # display app deployment information
    appverify
}
