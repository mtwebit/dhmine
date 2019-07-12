# DHmine - Digital Humanities Toolkit

## In progress...
Uploading components to github...

## About
DHmine is a collection of software tools used in Digital Humanities projects.  
Most of the tools are Web-based, they require a Web browser to run.

## Deployment
TODO: installation is changing... hold on...
First, deploy [WBcloud](https://github.com/mtwebit/webit-docker-services/) and its basic services (config, LDAP, Web Proxy).  
Then clone the DHmine repo and install the requested services using the WBcloud service deployment tool.
```sh
git clone https://github.com/mtwebit/dhmine.git
cd dhmine
../webit-cloud-services/wb-deploy.sh
```

## Acknowledgements
The toolkit is based on [Webit Cloud Services](https://github.com/mtwebit/webit-cloud-services/) (WBcloud), an open source framework for deploying Web-based microservices.  
The Stilometry Tool is based on [Shtylo](https://github.com/dobijan/shtylo).
