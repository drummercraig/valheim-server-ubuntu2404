
#!/bin/bash
echo "[AUTO RESTART] Checking if restart is allowed..."
if [ "$RESTART_IF_IDLE" = "true" ]; then
    # Check if players are connected (requires server query or log parsing)
    # Placeholder logic:
    if grep -q "No players connected" /valheim/server.log; then
        echo "[AUTO RESTART] No players connected. Restarting..."
        docker restart valheim-server
    else
        echo "[AUTO RESTART] Players online. Skipping restart."
    fi
else
    echo "[AUTO RESTART] Restarting regardless of player activity..."
    docker restart valheim-server
fi
