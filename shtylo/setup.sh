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
dockerimage="shtylo"

# build the image if it does not exists
if ! image_exists $dockerimage; then
  image_build shtylo
fi

if ! container_exists $containername; then
  if [ -z "$siport" ]; then
    prefixStrip="n" # do not strip the path prefix from the URL at the Web proxy
    siport="4700"
  fi

  service_setup

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
