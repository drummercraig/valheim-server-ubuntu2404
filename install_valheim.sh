#!/bin/bash
# Install/Update Valheim Server

set -e

echo "======================================"
echo "Valheim Server Installation"
echo "======================================"

# Check if Valheim is already installed
if [ -f "${VALHEIM_DIR}/valheim_server.x86_64" ]; then
    echo "✓ Valheim server already installed (skipping full download)"
    echo "Checking for updates..."
    
    OUTPUT=$(mktemp)
    if "${STEAMCMD_DIR}/steamcmd.sh" \
        +force_install_dir "${VALHEIM_DIR}" \
        +login anonymous \
        +app_update 896660 \
        +quit > "$OUTPUT" 2>&1; then
        rm -f "$OUTPUT"
        echo "✓ Valheim server up to date"
        echo "======================================"
        exit 0
    fi
    rm -f "$OUTPUT"
fi

# Function to install Valheim with retry logic
install_valheim() {
    local MAX_RETRIES=5
    local RETRY_DELAY=10
    local attempt=1
    
    while [ $attempt -le $MAX_RETRIES ]; do
        echo "Installation attempt $attempt of $MAX_RETRIES..."
        
        OUTPUT=$(mktemp)
        if "${STEAMCMD_DIR}/steamcmd.sh" \
            +force_install_dir "${VALHEIM_DIR}" \
            +login anonymous \
            +app_update 896660 validate \
            +quit > "$OUTPUT" 2>&1; then
            rm -f "$OUTPUT"
            echo "✓ Valheim server ready"
            return 0
        else
            EXIT_CODE=$?
            
            # Check if it's the "Missing configuration" error
            if grep -q "Missing configuration" "$OUTPUT"; then
                echo "⚠ Steam CDN issue detected (Missing configuration)"
                
                if [ $attempt -lt $MAX_RETRIES ]; then
                    echo "Retrying in ${RETRY_DELAY} seconds..."
                    sleep $RETRY_DELAY
                    RETRY_DELAY=$((RETRY_DELAY * 2))
                    attempt=$((attempt + 1))
                    rm -f "$OUTPUT"
                    continue
                fi
            fi
            
            # Not a retryable error or max retries reached
            echo "ERROR: SteamCMD failed with exit code $EXIT_CODE"
            echo ""
            echo "Common exit codes:"
            echo "  5 = No connection (check internet)"
            echo "  6 = Invalid credentials"
            echo "  7 = Steam Guard required"
            echo "  8 = Disk write failure / Permission issue / Steam CDN issue"
            echo "  10 = Busy (another instance running)"
            echo ""
            echo "Last 30 lines of output:"
            tail -30 "$OUTPUT"
            rm -f "$OUTPUT"
            return $EXIT_CODE
        fi
    done
    
    echo "ERROR: Failed after $MAX_RETRIES attempts"
    return 1
}

# Run installation with retry logic
install_valheim

echo "======================================"