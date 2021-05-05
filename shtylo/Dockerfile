FROM rocker/shiny:latest
WORKDIR /home
RUN apt update
RUN apt install -y --fix-missing git tk libssl-dev libsasl2-dev xdg-utils curl libprotobuf-dev
RUN R -e "install.packages('stylo')"
# RUN R -e "install.packages('mongolite')"
RUN R -e "install.packages('shinyBS')"
RUN R -e "install.packages('properties')"
RUN R -e "install.packages('readr')"
RUN R -e "install.packages('rjson')"
# RUN R -e "install.packages('RCurl')"
RUN R -e "install.packages('promises')"
RUN R -e "install.packages('future')"
RUN R -e "install.packages('ipc')"
RUN R -e "install.packages('utf8')"
RUN R -e "install.packages('yaml')"
RUN R -e "install.packages('cld3')"
RUN R -e "install.packages('base64enc')"
RUN mkdir -p shtylo
COPY entrypoint.sh /
RUN chmod 755 /entrypoint.sh
VOLUME ["/home/shtylo"]
CMD ["/entrypoint.sh"]
