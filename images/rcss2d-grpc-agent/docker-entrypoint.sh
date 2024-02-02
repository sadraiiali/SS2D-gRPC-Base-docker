#!/bin/env bash

export LD_LIBRARY_PATH=/app/bin/lib/:$LD_LIBRARY_PATH

/app/bin/sample_player \
    --host $HOST \
    --port $PORT \
    --g-ip $G_IP \
    --g_port $G_PORT \
    --teamname $TEAM_NAME \
    --player_conf /app/bin/player.conf \
    --config_dir /app/bin/formations-dt \
    --number 11 \
    --usecoach true \
    --unum 0 \
    --sleepprog sleep \
    --goaliesleep 1 \
    --sleeptime 0 \
    --offline_logging "" \
    --offline_mode "" \
    --fullstateopt ""
