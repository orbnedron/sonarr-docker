FROM debian:buster-slim
MAINTAINER orbnedron

# Define version of Sonarr
ARG SONARR_VERSION

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends gnupg dirmngr && \
    # Add sonarr repository
    export GNUPGHOME="$(mktemp -d)" && \
    gpg --batch --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys A236C58F409091A18ACA53CBEBFF6B99D9B78493 && \
    gpg --batch --export --armor A236C58F409091A18ACA53CBEBFF6B99D9B78493  > /etc/apt/trusted.gpg.d/sonarr.gpg.asc && \
    gpgconf --kill all && rm -rf "$GNUPGHOME" && \
    echo "deb http://apt.sonarr.tv/ master main" > /etc/apt/sources.list.d/sonarr.list && \
    # Install sonarr and support utils
    apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y nzbdrone=${SONARR_VERSION} mediainfo libtinyxml2.6.2v5 gosu curl && \
    # Cleanup
    apt-get purge -y --auto-remove gnupg dirmngr && \
    groupadd -r sonarr && useradd -r -g sonarr sonarr && \
    mkdir -p /config /media/downloads /media/series /media/series2 /media/series3

# Add start file
COPY ../docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

HEALTHCHECK --interval=5m --timeout=10s CMD curl -sSLf http://localhost:8989/ >/dev/null || exit 1

# Publish volumes, ports etc
VOLUME ["/config", "/media/downloads", "/media/series", "/media/series2", "/media/series3"]
EXPOSE 8989
WORKDIR /config

# Define default start command
CMD ["mono", "--debug", "/opt/NzbDrone/NzbDrone.exe", "-nobrowser", "-data=/config"]
