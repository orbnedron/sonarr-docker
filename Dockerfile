FROM orbnedron/mono-stretch-slim
MAINTAINER orbnedron

# Define version of Sonarr
ARG VERSION=2.0.0.5252

# Other Arguments
ARG DEBIAN_FRONTEND=noninteractive

# Install applications and some dependencies
RUN apt-get update -q \
    && apt-get install -qy procps curl mediainfo \
    && curl -L -o /tmp/sonarr.tar.gz http://download.sonarr.tv/v2/master/mono/NzbDrone.master.${VERSION}.mono.tar.gz \
    && tar xzf /tmp/sonarr.tar.gz -C /tmp/ \
    && mv /tmp/NzbDrone /opt/NzbDrone \
    && apt-get -y autoremove \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/tmp/* \
    && rm -rf /tmp/*

# Add start file
ADD start.sh /start.sh
RUN chmod 755 /start.sh

# Publish volumes, ports etc
VOLUME ["/config", "/media/downloads", "/media/series", "/media/series2", "/media/series3"]
EXPOSE 8989
WORKDIR /media/downloads

# Define default start command
CMD ["/start.sh"]
