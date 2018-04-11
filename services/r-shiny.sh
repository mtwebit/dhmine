#!/bin/bash
#
# Webit Cloud Services - R Shiny server
#
# Copyright 2018 Tamas Meszaros <mt+git@webit.hu>
# Licensed under Mozilla Public License v2.0 http://mozilla.org/MPL/2.0/
#

service="rshiny"
name="Shiny Web Apps server"
desc="It provides a server to run R Shiny apps"
required=0
dockerimage="rocker/shiny"
dockercontainer=$(getcontainername $dockerimage)

# Check requirements
function service_check_reqs {
  service_running $ldapserver && service_running $webproxy && service_running $mongodb
}

function service_installed() {
  [ "$dockercontainer" != "" ]
}
# update the service name
if service_installed; then service=$dockercontainer; fi

function service_selfcheck() {
  [ -s "$wbconf" ]
}

# Return if no action was specified
if [ "$1" == "" ]; then
  return
fi

if ! service_check_reqs; then
  error "Web Proxy and MongoDB are required to install this service."
  return
fi

# setting default values
if [ "$rshiny" == "" ]; then
  rshiny="rshiny" # container name
fi
containername=$rshiny

if [ "$dockercontainer" == "" ]; then
  echo "Installing $name..."
  ask rshiny "Short name for the $name docker container" $rshiny
  remember "$wbconf" rshiny
  containername=$rshiny
    #-v ${wbdir}/config/rshiny:/etc/shiny-server/ \
  setupcontainer --restart=unless-stopped --name $containername \
    --network ${dockernet} \
    --network-alias ${containername}.${dockernet} \
    -v ${wbdir}/config/rshiny:/etc/shiny-server/ \
    -v ${wbdir}/data/rshiny:/srv/shiny-server \
    -v ${wbdir}/logs/rshiny:/var/log/shiny-server \
    --label "traefik.backend=apps:rshiny" \
    --label "traefik.frontend.rule=Host:${wbhost};PathPrefix:/rshiny" \
    --label "traefik.frontend.passHostHeader=true" \
    --label "traefik.docker.network=${dockernet}" \
    --label "traefik.protocol=http" \
    --label "traefik.port=3838" \
    --label "traefik.enable=true" \
    $dockerimage
  if [ ! -s "${wbdir}/config/rshiny/shiny-server.conf" ]; then
    cat <<EOF > "${wbdir}/config/rshiny/shiny-server.conf"
# Instruct Shiny Server to run applications as the user "shiny"
run_as shiny;

# Define a server that listens on port 3838
server {
  listen 3838;

  location /rshiny {
    site_dir /srv/shiny-server;
    log_dir /var/log/shiny-server;
    directory_index on;
  }
  location /rshiny/shtylo {
    site_dir /srv/shiny-server/shtylo;
    log_dir /var/log/shiny-server;
    directory_index off;
  }
}
EOF
  fi

  debug "done."
# apt update && apt install libssl-dev libsasl2-dev
# chown -R shiny:shiny /tmp/workspace/ /srv/shiny-server/......
# install.packages("stylo")
# install.packages("mongolite")
# install.packages("shinyBS")
# install.packages("properties")
# cd /srv/shiny-server/; git clone....
else
  echo "Upgrading $name..."
  removecontainer $containername
  # recall this script to install the container again
  . $script
  return
fi

containerstatus "$name" $containername

