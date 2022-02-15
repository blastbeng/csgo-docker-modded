#!/usr/bin/bash

# Variables
IP="0.0.0.0"

echo "Starting server"
./srcds_run \
    -console \
    -usercon \
    -autoupdate \
    -game csgo \
    -tickrate $TICKRATE \
    -port $PORT \
    -maxplayers_override $MAXPLAYERS \
    -authkey $API_KEY
    +game_type 0 \
    +game_mode 0 \
    +mapgroup mg_active \
    +map de_dust2 \
    +ip $IP
