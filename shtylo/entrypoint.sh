#!/bin/bash

if [ ! -d /home/shtylo/src/ ]; then
  cd /home
  echo Installing Shtylo...
  git clone https://github.com/szakacsb/shtylo.git
  mkdir -p /home/shtylo/workdir
  chmod 777 /home/shtylo/workdir
fi
if [ ! -f /home/shtylo/src/.shiny_app.conf ]; then
  pushd /home/shtylo/src
  cat << EOF >.shiny_app.conf
db.url=mongodb://username:password@mongohost:27017
wd=/home/shtylo/workdir
custom.graph.file.prefix=graph
EOF
  echo "Review the contents of shtylo/src/.shiny_app.conf."
fi

# Start up the Shiny app
R -e "shiny::runApp('/home/shtylo/src', port=4700, host='0.0.0.0')"
