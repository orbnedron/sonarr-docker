# Sonarr docker image

<img src="https://badgen.net/docker/pulls/orbnedron/sonarr"> <a href="https://hub.docker.com/repository/docker/orbnedron/sonarr"><img src="https://badgen.net/badge/icon/docker?icon=docker&label"/></a> <a href="https://travis-ci.org/github/orbnedron/sonarr-docker"><img src="https://badgen.net/travis/orbnedron/sonarr-docker/master?icon=travis&label=build"/></a>

# Important notice

Versions of this docker image published after 2020-06-15 does not run Sonarr as root anymore, this might cause permission errors. 

# About

This is a Docker image for [Sonarr](https://sonarr.tv/) - the awesome tv series PVR for usenet and torrents.

# Build 

To build Sonarr container you can execute:
```bash
docker build --build-arg SONARR_VERSION=$SONARR_VERSION -t sonarr .
```

*```$SONARR_VERSION``` is version of Sonarr you want to install.*

# Run

To run it (with image on docker hub) :

```bash
    docker run -d -p 8989:8989 \
    -v <download path>:/media/downloads \
    -v <media path>:/media/series \
    -v <config path>:/config \
    -v /etc/localtime:/etc/localtime:ro \
    -e SONARR_USER_ID=`id -u $USER` -e SONARR_GROUP_ID=`id -g $USER`
    --restart unless-stopped \
    --name sonarr \
    orbnedron/sonarr
```

Open a browser and point it to [http://my-docker-host:8989](http://my-docker-host:8989)

### Run via Docker Compose

You can also run the Sonarr container by using [Docker Compose](https://www.docker.com/docker-compose).

If you've cloned the [git repository](https://github.com/orbnedron/sonarr-docker) you can build and run the Docker container locally (without the Docker Hub):

```bash
docker-compose up -d
```

If you want to use the Docker Hub image within your existing Docker Compose file you can use the following YAML snippet:

```yaml
sonarr:
    image: "orbnedron/sonarr"
    container_name: "sonarr"
    volumes:
        - "<download path>:/media/downloads"
        - "<media path 1>:/media/series"
        - "<media path 2>:/media/series2"
        - "<media path 3>:/media/series3"
        - "<config path>:/config"
    ports:
        - "8989:8989"
    restart: unless-stopped
#    environment:
#      - SONARR_USER_ID=1000
#      - SONARR_GROUP_ID=1000
```

### Volumes

Please mount the following volumes inside your Sonarr container:

* `/media/downloads`: Holds all the downloaded data (e.g. dropbox folders)
* `/media/series`: Directory for media files (e.g. tv series), up to 3 folders
* `/config`: Directory for configuration files

### Configuration file

By default the Sonarr configuration is located on `/config`.
