#!/bin/bash
echo "[CONFIG SYNC] Syncing config..."
rsync -av --delete "$CONFIG_SRC/" "$CONFIG_DEST/"
