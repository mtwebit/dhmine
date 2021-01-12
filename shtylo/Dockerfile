FROM rocker/shiny:3.5.1
WORKDIR /home
RUN apt update
RUN apt install -y --fix-missing git tk libssl-dev libsasl2-dev xdg-utils
RUN R -e "install.packages('stylo')"
RUN R -e "install.packages('mongolite')"
RUN R -e "install.packages('shinyBS')"
RUN R -e "install.packages('properties')"
RUN R -e "install.packages('readr')"
RUN git clone https://github.com/szakacsb/shtylo.git
COPY entrypoint.sh /
RUN chmod 755 /entrypoint.sh
VOLUME ["/home/shtylo"]
CMD ["/entrypoint.sh"]
