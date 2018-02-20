#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`
BASE_PATH=${SCRIPTPATH}

source "${BASE_PATH}/create_cfg.sh"


if [ "${SOURCE_NAME}" = "bw" ]; then
    URL="http://download.geofabrik.de/europe/germany/baden-wuerttemberg-latest.osm.pbf"
elif [ "${SOURCE_NAME}" = "de" ]; then
    URL="http://download.geofabrik.de/europe/germany-latest.osm.pbf"
elif [ "${SOURCE_NAME}" = "eu" ]; then
    URL="http://download.geofabrik.de/europe-latest.osm.pbf"
elif  [ "${SOURCE_NAME}" = "eu" ]; then
    URL="https://ftp5.gwdg.de/pub/misc/openstreetmap/planet.openstreetmap.org/pbf/planet-latest.osm.pbf"
fi

if [ ! -s "${SRC_DIR}/${SOURCE_NAME}.osm.pbf" ]; then
    wget "${URL}" -O ${SRC_DIR}/${SOURCE_NAME}.osm.pbf
else
    echo "Source for ${SOURCE_NAME} is already present"
fi