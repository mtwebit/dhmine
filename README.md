# DHmine - Digital Humanities Toolkit

## About
DHmine is a collection of software tools used in Digital Humanities projects.  
Most of the tools are Web-based, they require a Web browser to run.

## Deployment
First, clone [WBcloud](https://github.com/mtwebit/webit-docker-services/). We use it to manage a DHmine installation.  
Then clone the DHmine repo and install the requested services using the WBcloud service deployment tool.
```sh
git clone https://github.com/mtwebit/webit-cloud-services.git
cd webit-cloud-services
git clone https://github.com/mtwebit/dhmine.git
./wbsetup.sh
```
This deployment tool provides a menu-driven installation for various services. It asks a few questions about your installation (e.g. home directory, name, URLs etc.) and configures the entire system accordingly.

## Acknowledgements
The toolkit uses [Webit Cloud Services](https://github.com/mtwebit/webit-cloud-services/) (WBcloud), an open source framework for deploying Web-based microservices.  
The Stilometry Tool is based on [Shtylo](https://github.com/dobijan/shtylo).
... TODO finish the list :) ...
