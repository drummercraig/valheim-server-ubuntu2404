#!/bin/bash
echo "[EVENT] Server stopping..."
source /config/settings.env
bash /scripts/world_backup.sh
