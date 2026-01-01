
#!/bin/bash
echo "[EVENT] Server starting..."
source /config/settings.env

# Ensure folder structure exists
mkdir -p /valheim-data/BepInEx/plugins /valheim-data/BepInEx/patchers /valheim-data/BepInEx/config
mkdir -p /valheim-data/worlds /valheim-data/backups

# Apply initial permissions
chown -R ${PUID}:${PGID} /valheim-data
chmod -R 755 /valheim-data

# Install mod loader if missing
case "$MOD_LOADER" in
  "BepInEx")
    if [ ! -d "$VALHEIM_SERVER_DIR/BepInEx" ]; then
      echo "[MOD LOADER] Installing BepInEx..."
      wget -q https://github.com/BepInEx/BepInEx/releases/download/v5.4.21/BepInEx_UnityMono_x64_5.4.21.0.zip
      unzip -q BepInEx_UnityMono_x64_5.4.21.0.zip -d $VALHEIM_SERVER_DIR
    fi
    echo "[MOD LOADER] Syncing BepInEx mods..."
    bash /scripts/plugin_sync.sh
    bash /scripts/patcher_sync.sh
    bash /scripts/config_sync.sh
    ;;
  "ValheimPlus")
    if [ ! -d "$VALHEIM_SERVER_DIR/BepInEx" ]; then
      echo "[MOD LOADER] Installing ValheimPlus..."
      wget -q https://github.com/valheimPlus/ValheimPlus/releases/latest/download/UnixServer.zip
      unzip -q UnixServer.zip -d $VALHEIM_SERVER_DIR
    fi
    echo "[MOD LOADER] Syncing ValheimPlus configs..."
    bash /scripts/config_sync.sh
    ;;
  "None")
    echo "[MOD LOADER] Vanilla mode selected. Skipping mod installation."
    ;;
esac

# Restore world and update server
bash /scripts/world_restore.sh
bash /scripts/auto_update.sh

# Setup cron for restart and backups
if [ "$RESTART_CRON" != "disabled" ]; then
    echo "$RESTART_CRON root /scripts/auto_restart.sh" >> /etc/crontab
fi
echo "*/$(($BACKUP_SAVEINTERVAL / 60)) * * * * root /scripts/world_backup.sh" >> /etc/crontab
service cron start

# Start server
$VALHEIM_SERVER_DIR/valheim_server.x86_64 \
    -name "${SERVER_NAME}" \
    -port "${SERVER_PORT}" \
    -world "${WORLD_NAME}" \
    -password "${SERVER_PASSWORD}" \
    -public "${SERVER_PUBLIC}" \
    -crossplay "${CROSSPLAY_ENABLED}" &
SERVER_PID=$!

# Wait 15 minutes then reapply permissions
sleep 900
chown -R ${PUID}:${PGID} /valheim-data
chmod -R 755 /valheim-data

wait $SERVER_PID
``
