#!/bin/bash
echo "[WORLD RESTORE] Restoring world..."
rsync -av --delete "$WORLD_BACKUP/" "$WORLD_SRC/"
