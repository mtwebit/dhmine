#!/bin/bash
# Shell script to setup Docker containers for DHmine
#
# Copyright 2017 Tamas Meszaros <mt+git@webit.hu>
# This file licensed under Mozilla Public License v2.0 http://mozilla.org/MPL/2.0/
#
# To quickly grab a fresh copy of this file
# curl -Os https://raw.githubusercontent.com/mtwebit/dhmine/master/base/SetupDHmineEnv.sh && chmod 700 SetupDHmineEnv.sh

# Ask a question and provide a default answer
# Sets the variable to the answer or the default value
# 1:varname 2:question 3:default value
function ask() {
  echo -n "${2} [$3]: "
  read pp
  if [ "$pp" == "" ]; then
    export ${1}="${3}"
  else
    export ${1}="${pp}"
  fi
}

# Ask a yes/no question, returns true on answering y
# 1:question 2:default answer
function askif() {
  ask ypp "$1" "$2"
  [ "$ypp" == "y" ]
}

echo "*** DHmine Docker environment setup ***"
dhdir=`pwd`
ask dhdir "Directory that holds the DHmine installation" "$dhdir"
echo -n "$dhdir..."
if [ ! -d $dhdir ]; then
  echo "does not exists. Creating it."
  mkdir -p $dhdir
fi
mkdir -p ${dhdir}/config/certs ${dhdir}/databases ${dhdir}/websites ${dhdir}/storage

echo -n "Checking for Docker..."

if [ ! -x /usr/bin/docker ]; then
  echo "ERROR: Docker is not installed."
  echo "You have to install it in order to setup DHmine."
  exit 2
else
  echo "found at /usr/bin/docker."
fi

# checking for known docker containers

echo -n "Checking for a Web proxy server..."
webproxy=$(docker ps -q --filter "ancestor=jwilder/nginx-proxy")
if [ "$webproxy" == "" ]; then
  echo "not found."
  echo "A Web proxy server is required to bridge Web sites to the outside network."
  if askif "Install an Nginx Web proxy container (required)?" "y"; then
    ask webproxy "Short name for the Nginx proxy container" "webproxy"
    docker create --restart=unless-stopped --name $webproxy \
      -p 80:80 -p 443:443 \
      -v ${dhdir}/config/certs:/etc/nginx/certs \
      -v ${dhdir}/config/nginx.conf.d:/etc/nginx/conf.d \
      -v ${dhdir}/config/nginx.vhost.d:/etc/nginx/vhost.d:ro \
      -v /var/run/docker.sock:/tmp/docker.sock:ro \
      -v /usr/share/nginx/html \
      --label com.github.jrcs.letsencrypt_nginx_proxy_companion.nginx_proxy \
      jwilder/nginx-proxy:alpine || exit 1
    docker start $webproxy ||  exit 1
  else
    exit 2
  fi
fi
webproxy=$(docker inspect --format "{{.Name}}" $webproxy)
echo -n "Web proxy container named '$webproxy' "
docker inspect --format "{{.State.Status}}" $webproxy

echo -n "Checking for a Let's encrypt companion container..."
letsencrypt=$(docker ps -q --filter "ancestor=jrcs/letsencrypt-nginx-proxy-companion")
if [ "$letsencrypt" == "" ]; then
  echo "not found."
  echo "SSL certificates used by Web sites can be automagically generated and maintained by letsencrypt.org."
  if askif "Install a letsencrypt companion container (recommended)?" "y"; then
    ask letsencrypt "Short name for the letsencrypt container" "letsencrypt"
    docker create --restart=unless-stopped --name $letsencrypt \
      --volumes-from $webproxy -v ${dhdir}/config/certs:/etc/nginx/certs:rw \
      -v /var/run/docker.sock:/var/run/docker.sock:ro \
      jrcs/letsencrypt-nginx-proxy-companion || exit 1
    docker start $letsencrypt ||  exit 1
  fi
fi
letsencrypt=$(docker inspect --format "{{.Name}}" $letsencrypt)
echo -n "Letsencrypt container named '$letsencrypt' "
docker inspect --format "{{.State.Status}}" $letsencrypt

