# DHmine - Digital Humanities Toolkit

## About
DHmine is a collection of software tools used in Digital Humanities projects.  
Most of the tools are Web-based, they require Docker to run and a Web browser to access them.
You can find video demonstrations and application examples [here](https://dh.mit.bme.hu/en/software/).

We are currently reorganizing the structure of this repo and uploading additional services.  

## Deployment
First, clone [WBcloud](https://github.com/mtwebit/webit-cloud-services/). We use it to manage a DHmine installation.  
Then clone the DHmine repo and install the requested services using the WBcloud service deployment tool.
```sh
git clone https://github.com/mtwebit/webit-cloud-services.git
cd webit-cloud-services
git clone https://github.com/mtwebit/dhmine.git
./wbsetup.sh
```
This deployment tool provides a menu-driven installation for various services. It asks a few questions about your installation (e.g. home directory, name, URLs etc.) and configures the entire system accordingly.

## A brief history
The development of DHmine started in 2015 to support various DH projects.
We developed many modules during subsequent projects, a couple of them were published on Github.  
In 2019 most DHmine services were moved to a more general framework called [Webit Cloud Services](https://github.com/mtwebit/webit-cloud-services/) (WBcloud).

## Acknowledgements
The Stilometry Tool is based on [Shtylo](https://github.com/dobijan/shtylo).
... TODO finish the list :) ...
