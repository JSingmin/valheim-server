#!/bin/sh
/opt/steamcmd/steamcmd.sh +login anonymous +app_update 896660 validate +quit

export TEMP_LD_PATH=$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=./linux64:$LD_LIBRARY_PATH
export SteamAppId=892970

/root/Steam/steamapps/common/Valheim\ dedicated\ server/valheim_server.x86_64 \
  -name "$SERVER_NAME" \
  -port 2456 \
  -world "$SERVER_WORLD" \
  -password "$SERVER_PASSWORD" \
  -savedir "/storage" \
  -public 0 \
  -nographics

export LD_LIBRARY_PATH=$TEMP_LD_PATH
