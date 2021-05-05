#!/bin/bash

if [ ! -d "/home/shtylo/src/" ]; then
  cd /home/shtylo
  echo "Installing Shtylo..."
  git clone --branch rework https://github.com/mtbme/shtylo.git
  ln -s shtylo/src .
  echo "Review the contents of src/.shiny_app.conf."
fi

if [ ! -d /home/shtylo/workdir/ ]; then
  mkdir -p workdir
  chmod 777 workdir
fi

# Start up the Shiny app
R -e "shiny::runApp('/home/shtylo/src', port=4700, host='0.0.0.0')"
