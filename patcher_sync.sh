#!/bin/bash
echo "[PATCHER SYNC] Syncing patchers..."
rsync -av --delete "$PATCHER_SRC/" "$PATCHER_DEST/"
