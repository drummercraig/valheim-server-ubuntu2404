
#!/bin/bash
echo "[INSTALL] Installing ValheimPlus..."
mkdir -p $VALHEIM_SERVER_DIR
cd $VALHEIM_SERVER_DIR
wget -q "${VALHEIMPLUS_URL:-https://github.com/valheimPlus/ValheimPlus/releases/latest/download/UnixServer.zip}"
unzip -q UnixServer.zip -d $VALHEIM_SERVER_DIR
echo "[INSTALL] ValheimPlus installed successfully."
