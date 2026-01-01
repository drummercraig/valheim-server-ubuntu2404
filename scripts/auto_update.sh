#!/bin/bash
echo "[AUTO UPDATE] Checking for updates..."
$STEAMCMD_DIR/steamcmd.sh +login anonymous +force_install_dir $VALHEIM_SERVER_DIR +app_update 896660 validate +quit
