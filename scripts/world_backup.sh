#!/bin/bash
echo "[WORLD BACKUP] Backing up world..."
rsync -av --delete "$WORLD_SRC/" "$WORLD_BACKUP/"
