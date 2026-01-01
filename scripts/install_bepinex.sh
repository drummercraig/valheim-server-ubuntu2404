#!/bin/bash
echo "[INSTALL] Installing Valheim server..."
mkdir -p $STEAMCMD_DIR
cd $STEAMCMD_DIR
wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
tar -xvzf steamcmd_linux.tar.gz
./steamcmd.sh +login anonymous +force_install_dir $VALHEIM_SERVER_DIR +app_update 896660 validate +quit
