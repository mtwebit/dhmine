#!/bin/bash
#
# Webit Cloud Services Toolkit - Shtylo service
#
# Copyright 2020 Tamas Meszaros <mt+git@webit.hu>
# Licensed under Mozilla Public License v2.0 http://mozilla.org/MPL/2.0/
# 

title="Shtylo"
desc="A Web-based stilomety tool"

# The image file
dockerimage="shtylo:latest"

# build the image if it does not exists
if ! image_exists $dockerimage; then
  image_build shtylo
fi

if ! container_exists $containername; then
  if [ -z "$siport" ]; then
    prefixStrip="y"
    siport="4700"
    htuser="demo"
    htpassword=`generate_password`
  fi

  service_setup

  ask htuser "HTTP Basic Auth username" $htuser
  remember "$serviceconf" htuser
  ask htpassword "HTTP Basic Auth password" $htpassword
  remember "$serviceconf" htpassword

  if [ ! -f "${wbconfigdir}/traefik/${containername}.htpasswd" ]; then
    info "Creating "${wbconfigdir}/traefik/${containername}.htpasswd"..."
    touch "${wbconfigdir}/traefik/${containername}.htpasswd"
  fi
  info "Storing password in ${wbconfigdir}/traefik/${containername}.htpasswd"
  echo "${htuser}:`encode_htpasswd $htpassword`" >"${wbconfigdir}/traefik/${containername}.htpasswd"

    # -v ${servicelogdir}:/var/log/shiny-server \
  container_setup "$dockerimage" $containername \
    -v ${servicedatadir}:/home/shtylo \
    --label "traefik.frontend.passHostHeader=true" \
    --label "traefik.frontend.auth.basic.removeHeader=false" \
    --label "traefik.frontend.auth.headerField=X-WebAuth-User" \
    --label "traefik.frontend.auth.basic.usersFile=/etc/traefik/${containername}.htpasswd"
else
  if askif "Update the $title service?" y; then
    container_remove $containername
    . ${BASH_SOURCE[0]}
  fi
fi

# Start the container if it is not running
container_running $containername || container_start $containername
