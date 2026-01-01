#!/bin/bash
echo "[EVENT] Manual backup triggered..."
source config/settings.env
bash scripts/world_backup.sh
