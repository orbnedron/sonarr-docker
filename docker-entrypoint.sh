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
GROUP_ID=${SONARR_GROUP_ID:-1000}

echo "Starting with UID : $USER_ID, GID: $GROUP_ID"

# If the provided uid/gid does not exist ignore creation, otherwise create
if [ 1 -gt $(cat /etc/group | awk -F ":" '{ print $3 }' | grep -w $GROUP_ID | wc -l) ]; then
  echo "Creating group sonarr"
  addgroup -g $GROUP_ID sonarr
else
  echo "Group id $GROUP_ID already exist, using that"
fi

if [ 1 -gt $(cat /etc/passwd | awk -F ":" '{ print $3 }' | grep -w $USER_ID | wc -l) ]; then
  echo "Creating user sonarr"
  GROUP_NAME=$(cat /etc/group | awk -F ":" '{ print $1,$3 }' | grep -w $GROUP_ID | awk '{ print $1 }')
  adduser --shell /bin/sh --uid $USER_ID --disabled-password --no-create-home -G $GROUP_NAME sonarr
else
  echo "User id $USER_ID already exist, using that"
fi


XDG_CONFIG_HOME="/config"

if [ "$(id -u)" = "0" ]; then
  chown -R $USER_ID:$GROUP_ID /config
  chown -R $USER_ID:$GROUP_ID /opt/NzbDrone
  set -- gosu $USER_ID:$GROUP_ID "$@"
fi

exec "$@"
