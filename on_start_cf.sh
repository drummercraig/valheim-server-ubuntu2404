#!/bin/bash

source settings.env

# Ensure folder structure exists
mkdir -p /valheim-data/BepInEx/plugins /valheim-data/BepInEx/patchers /valheim-data/BepInEx/config
mkdir -p /valheim-data/worlds /valheim-data/backups

# Apply initial permissions
chown -R ${PUID}:${PGID} /valheim-data
chmod -R 755 /valheim-data

install_steamcmd.sh
install_valheim.sh