#!/bin/bash
if [ ! -f "$VALHEIM_SERVER_DIR/valheim_server.x86_64" ]; then
    echo "[INSTALL] Installing Valheim server..."
    $STEAMCMD_DIR/steamcmd.sh +login anonymous +force_install_dir $VALHEIM_SERVER_DIR +app_update 896660 validate +quit
fi

echo "[EVENT] Server starting..."
source settings.env

# Validate MOD_LOADER
VALID_LOADERS=("BepInEx" "ValheimPlus" "None")
if [[ ! " ${VALID_LOADERS[@]} " =~ " ${MOD_LOADER} " ]]; then
    echo "[MOD LOADER] Invalid option '${MOD_LOADER}'. Defaulting to 'None'."
    MOD_LOADER="None"
fi

# Ensure folder structure exists
mkdir -p /valheim-data/BepInEx/plugins /valheim-data/BepInEx/patchers /valheim-data/BepInEx/config
mkdir -p /valheim-data/worlds /valheim-data/backups

# Apply initial permissions
chown -R ${PUID}:${PGID} /valheim-data
chmod -R 755 /valheim-data

# Install mod loader if missing
case "$MOD_LOADER" in
  "BepInEx")
    echo "[MOD LOADER] Selected: BepInEx"
    if [ ! -d "$VALHEIM_SERVER_DIR/BepInEx" ]; then
      echo "[MOD LOADER] Installing BepInEx..."
      #wget -q "${BEPINEX_URL}"
      #unzip -q BepInEx_UnityMono_x64_5.4.21.0.zip -d $VALHEIM_SERVER_DIR
      
      wget -O BepInEx.zip "${BEPINEX_URL}"
      unzip -q BepInEx.zip -d $VALHEIM_SERVER_DIR

    fi
    echo "[MOD LOADER] Syncing BepInEx mods..."
    bash plugin_sync.sh
    bash patcher_sync.sh
    bash config_sync.sh
    ;;
  "ValheimPlus")
    echo "[MOD LOADER] Selected: ValheimPlus"
    if [ ! -d "$VALHEIM_SERVER_DIR/BepInEx" ]; then
      echo "[MOD LOADER] Installing ValheimPlus..."
      #wget -q "${VALHEIMPLUS_URL}"
      #unzip -q UnixServer.zip -d $VALHEIM_SERVER_DIR
      
      wget -O ValheimPlus.zip "${VALHEIMPLUS_URL}"
      unzip -q ValheimPlus.zip -d $VALHEIM_SERVER_DIR

    fi
    echo "[MOD LOADER] Syncing ValheimPlus mods..."
    bash plugin_sync.sh
    bash patcher_sync.sh
    bash config_sync.sh
    ;;
  "None")
    echo "[MOD LOADER] Vanilla mode selected. Skipping mod installation."
    ;;
esac

# Restore world and update server
bash world_restore.sh
bash auto_update.sh

# Setup cron for restart and backups
if [ "$RESTART_CRON" != "disabled" ]; then
    echo "$RESTART_CRON root auto_restart.sh" >> /etc/crontab
fi
echo "*/$(($BACKUP_SAVEINTERVAL / 60)) * * * * root world_backup.sh" >> /etc/crontab
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