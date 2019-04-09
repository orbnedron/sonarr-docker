FROM orbnedron/mono-alpine
MAINTAINER orbnedron

# Define version of Sonarr
ARG VERSION=2.0.0.5322

RUN apk add --no-cache  --virtual=.package-dependencies curl tar gzip && \
    apk add --no-cache mediainfo --repository http://dl-cdn.alpinelinux.org/alpine/edge/community && \
    curl -L -o /tmp/sonarr.tar.gz http://download.sonarr.tv/v2/master/mono/NzbDrone.master.${VERSION}.mono.tar.gz && \
    tar xzf /tmp/sonarr.tar.gz -C /tmp/ && \
    mkdir -p /opt && \
    mv /tmp/NzbDrone /opt/NzbDrone && \
    rm -rf /var/tmp/* && \
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/* && \
    apk del .package-dependencies

# Add start file
ADD start.sh /start.sh
RUN chmod 755 /start.sh

# Publish volumes, ports etc
VOLUME ["/config", "/media/downloads", "/media/series", "/media/series2", "/media/series3"]
EXPOSE 8989
WORKDIR /media/downloads

# Define default start command
CMD ["/start.sh"]
