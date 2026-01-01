# Valheim Server - Ubuntu 24.04 Docker

A comprehensive Docker-based Valheim dedicated server solution for Ubuntu 24.04 with support for mod loaders (BepInEx, ValheimPlus), automated backups, scheduled restarts, and easy configuration.

## Setup Steps

1. **Install Prerequisites**
   - Ensure Docker and Docker Compose are installed on Ubuntu 24.04
   - Forward ports 2456-2458 UDP on your router (if hosting from home)

2. **Download the Repository**
   ```bash
   git clone <repository-url>
   cd valheim-server
   ```

3. **Configure Your Server**
   ```bash
   cp .env_example .env
   nano .env  # Edit with your settings
   ```
   - Set `SERVER_NAME` (your server's display name)
   - Set `SERVER_PASSWORD` (required for players to join)
   - Set `WORLD_NAME` (your world file name)
   - Choose `MOD_LOADER` (BepInEx, ValheimPlus, or None)

4. **Start the Server**
   ```bash
   docker-compose up -d
   ```

5. **Verify It's Running**
   ```bash
   docker logs -f valheim-server
   ```
   Look for "Game server connected" in the logs

6. **Connect to Your Server**
   - In Valheim, go to "Join Game" → "Add server"
   - Enter your server IP and port (default: 2456)
   - Enter the password you set in `.env`

That's it! Your server is now running. See below for detailed configuration options and management commands.

## Features

- **Dockerized Setup**: Easy deployment using Docker or Docker Compose
- **Mod Loader Support**: Choose between BepInEx, ValheimPlus, or vanilla
- **Automated Backups**: Configurable backup intervals with retention policies
- **Scheduled Restarts**: Cron-based server restarts with idle detection
- **Crossplay Support**: Enable or disable crossplay functionality
- **World Management**: Automatic world backup and restore functionality
- **Persistent Storage**: All data stored in mounted volumes for persistence

## Prerequisites

- Ubuntu 24.04 (or compatible Linux distribution)
- Docker and Docker Compose installed
- Ports 2456-2458 (UDP) available and forwarded if behind NAT

## Quick Start

### Using Docker Compose (Recommended)

1. Clone or download this repository
2. Copy the example environment file:
   ```bash
   cp .env_example .env
   ```
3. Edit `.env` with your server settings:
   ```bash
   nano .env
   ```
4. Start the server:
   ```bash
   docker-compose up -d
   ```

### Using Docker Run

1. Copy the example environment file:
   ```bash
   cp .env_example .env
   ```
2. Edit `.env` with your server settings
3. Run the server using the provided script:
   ```bash
   chmod +x docker_run_env.sh
   ./docker_run_env.sh
   ```

## Configuration

### Server Identity

Configure your server's basic settings in the `.env` file:

```env
SERVER_NAME=My Valheim Server    # Server name visible in server list
WORLD_NAME=Dedicated             # World file name
SERVER_PASSWORD=secret           # Password to join (required)
SERVER_PUBLIC=1                  # 1 for public, 0 for private
SERVER_PORT=2456                 # Default port (2456-2458 used)
```

### Crossplay

Enable or disable crossplay between PC and console players:

```env
CROSSPLAY_ENABLED=false          # true or false
```

### Mod Loader

Choose your preferred mod loader:

```env
MOD_LOADER=BepInEx               # Options: BepInEx, ValheimPlus, None
BEPINEX_URL=https://github.com/BepInEx/BepInEx/releases/download/v5.4.21/BepInEx_UnityMono_x64_5.4.21.0.zip
VALHEIMPLUS_URL=https://github.com/valheimPlus/ValheimPlus/releases/latest/download/UnixServer.zip
```

To add mods:
- Place BepInEx plugins in `./valheim-data/BepInEx/plugins/`
- Place BepInEx patchers in `./valheim-data/BepInEx/patchers/`
- Place config files in `./valheim-data/BepInEx/config/`

### Backups

Configure automatic world backups:

```env
BACKUP_SAVEINTERVAL=1800         # Backup interval in seconds (30 minutes)
BACKUP_COUNT=96                  # Number of backups to retain
BACKUP_SHORT=7200                # Short backup interval (2 hours)
BACKUP_LONG=43200                # Long backup interval (12 hours)
```

Backups are stored in `./valheim-data/backups/`

### Scheduled Restarts

Configure automatic server restarts:

```env
RESTART_CRON=0 5 * * *           # Cron schedule (daily at 5 AM)
RESTART_IF_IDLE=true             # Only restart if no players online
TZ=America/Phoenix               # Timezone for cron jobs
```

### System Settings

User and group IDs for file permissions:

```env
PUID=1000                        # User ID
PGID=1000                        # Group ID
```

## Directory Structure

```
.
├── docker-compose.yml           # Docker Compose configuration
├── Dockerfile                   # Docker image definition
├── .env                         # Your configuration (create from .env_example)
├── .env_example                 # Example configuration file
├── valheim-data/                # Persistent data directory
│   ├── worlds/                  # World save files
│   ├── backups/                 # World backups
│   └── BepInEx/                 # Mod files (if using mod loader)
│       ├── plugins/             # BepInEx plugins
│       ├── patchers/            # BepInEx patchers
│       └── config/              # Mod configuration files
└── scripts/                     # Server management scripts
```

## Management Commands

### View Server Logs
```bash
docker logs -f valheim-server
```

### Stop Server
```bash
docker stop valheim-server
```

### Start Server
```bash
docker start valheim-server
```

### Restart Server
```bash
docker restart valheim-server
```

### Manual Backup
```bash
docker exec valheim-server /valheim-server/on_backup.sh
```

### Update Server
```bash
docker-compose down
docker-compose pull
docker-compose up -d
```

## Port Configuration

The server uses three consecutive UDP ports:

- **2456**: Game port (configurable via SERVER_PORT)
- **2457**: Query port (SERVER_PORT + 1)
- **2458**: Additional port (SERVER_PORT + 2)

Ensure these ports are:
1. Allowed through your firewall
2. Forwarded in your router (if hosting from home)

## Troubleshooting

### Server won't start
- Check logs: `docker logs valheim-server`
- Verify ports are not in use: `netstat -tulpn | grep 2456`
- Ensure `.env` file exists and is properly configured

### Players can't connect
- Verify ports 2456-2458 UDP are forwarded
- Check firewall rules
- Confirm SERVER_PASSWORD matches what players are using
- Ensure SERVER_PUBLIC is set to 1 for public listing

### Mods not loading
- Verify MOD_LOADER is set to "BepInEx" or "ValheimPlus"
- Check mod files are in correct directories under `valheim-data/BepInEx/`
- Review logs for mod-related errors

### Backups not working
- Check BACKUP_SAVEINTERVAL is set correctly
- Verify `valheim-data/backups/` directory permissions
- Review cron logs: `docker exec valheim-server cat /var/log/cron.log`

## Advanced Configuration

### Custom Cron Schedule

The `RESTART_CRON` variable uses standard cron syntax:

```
* * * * *
│ │ │ │ │
│ │ │ │ └─── Day of week (0-7, Sun-Sat)
│ │ │ └───── Month (1-12)
│ │ └─────── Day of month (1-31)
│ └───────── Hour (0-23)
└─────────── Minute (0-59)
```

Examples:
- `0 5 * * *` - Daily at 5:00 AM
- `0 */6 * * *` - Every 6 hours
- `0 3 * * 0` - Every Sunday at 3:00 AM

### Idle Detection

When `RESTART_IF_IDLE=true`, the server checks for active players before restarting. This prevents disrupting active gameplay sessions.

## Building from Source

To build the Docker image locally:

```bash
docker build -t valheim-server:latest .
```

## Contributing

Feel free to submit issues, fork the repository, and create pull requests for any improvements.

## Support

For issues and questions:
- Check the [Valheim Dedicated Server Wiki](https://valheim.fandom.com/wiki/Dedicated_server)
- Review Docker logs for error messages
- Ensure your configuration matches the examples provided

## License

This project is provided as-is for running Valheim dedicated servers. Valheim is a trademark of Iron Gate Studio.

## Acknowledgments

- Iron Gate Studio for Valheim
- BepInEx community for the mod loader
- ValheimPlus team for their enhanced server mod