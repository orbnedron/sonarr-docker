#!/usr/bin/env sh
set -e
# Run commands in the Docker container with a particular UID and GID.
# The idea is to run the container like
#   docker run -i \
#     -v `pwd`:/work \
#     -e SONARR_USER_ID=`id -u $USER` \
#     -e SONARR_GROUP_ID=`id -g $USER` \
#     image-name bash
# where the -e flags pass the env vars to the container, which are read by this script.
# By setting copying this script to the container and setting it to the
# ENTRYPOINT, and subsequent commands run in the container will run as the user
# who ran `docker` on the host, and so any output files will have the correct
# permissions.

USER_ID=${SONARR_USER_ID:-1000}
GROUP_ID=${SONARR_GROUP_ID:-$USER_ID}

echo "Starting with UID : $USER_ID, GID: $GROUP_ID"
addgroup -g $GROUP_ID sonarr
adduser --shell /bin/sh --uid $USER_ID --disabled-password --ingroup sonarr sonarr

if [ "$(id -u)" = "0" ]; then
  chown -R sonarr:sonarr /config
  set -- gosu sonarr:sonarr "$@"
fi

exec "$@"
