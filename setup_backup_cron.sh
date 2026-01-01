
#!/bin/bash
echo "[BACKUP] Setting up backup schedule..."
echo "*/$(($BACKUP_SAVEINTERVAL / 60)) * * * * root world_backup.sh" >> /etc/crontab
service cron restart
