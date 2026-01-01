#!/bin/bash
echo "[PLUGIN SYNC] Syncing plugins..."
rsync -av --delete "$PLUGIN_SRC/" "$PLUGIN_DEST/"
