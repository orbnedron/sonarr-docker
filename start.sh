#!/usr/bin/env sh
set -e


echo "Sonarr settings"
echo "===================="
echo
echo "  Config:     ${CONFIG:=/config}"
echo

# Define variables to use when starting application
CONFIG=${CONFIG:-/config}

echo "Starting Sonarr..."
mono --debug /opt/NzbDrone/NzbDrone.exe -nobrowser -data=${CONFIG}

