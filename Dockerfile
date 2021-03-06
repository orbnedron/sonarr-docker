FROM alpine:latest
MAINTAINER orbnedron

# Define version of Sonarr
ARG SONARR_VERSION

#   Install support applications
RUN apk add --no-cache mono gosu curl --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing && \
    apk add --no-cache mediainfo tinyxml2 --repository http://dl-cdn.alpinelinux.org/alpine/edge/community && \
    # Install ca-certificates
    apk add --no-cache --virtual=.build-dependencies ca-certificates && \
    cert-sync /etc/ssl/certs/ca-certificates.crt && \
    # Download and install sonarr
    apk add --no-cache --virtual=.package-dependencies tar gzip && \
    curl -L -o /tmp/sonarr.tar.gz "https://services.sonarr.tv/v1/download/main/latest?version=3&os=linux" && \
    tar xzf /tmp/sonarr.tar.gz -C /tmp/ && \
    mkdir -p /opt && \
    mv /tmp/Sonarr /opt/Sonarr && \
    # Cleanup
    rm -rf /var/tmp/* && \
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/* && \
    apk del .package-dependencies

# Add start file
ADD docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

# Publish volumes, ports etc
VOLUME ["/config", "/media/downloads", "/media/series", "/media/series2", "/media/series3"]
EXPOSE 8989
WORKDIR /config

# Define default start command
CMD ["mono", "--debug", "/opt/Sonarr/Sonarr.exe", "-nobrowser", "-data=/config"]

