FROM debian:stretch-slim
MAINTAINER orbnedron

# Define version of Sonarr
ARG VERSION=2.0.0.5252

# Other Arguments
ARG DEBIAN_FRONTEND=noninteractive

# Add start file
ADD start.sh /start.sh
RUN chmod 755 /start.sh

# Install mono
RUN apt-get update -q \
    && apt-get install -qy gnupg2 \
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
    && echo "deb http://download.mono-project.com/repo/debian stable-stretch main" > /etc/apt/sources.list.d/mono-official-stable.list \
    && apt-get update -q \
    && apt-get install -qy libmono-cil-dev ca-certificates-mono

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

# Publish volumes, ports etc
VOLUME ["/config", "/media/downloads", "/media/series", "/media/series2", "/media/series3"]
EXPOSE 8989
WORKDIR /media/downloads

# Define default start command
CMD ["/start.sh"]
