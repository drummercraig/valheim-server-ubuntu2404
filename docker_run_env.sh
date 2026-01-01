
#!/bin/bash
# Run Valheim Server using environment variables from .env file

docker run -d \
  --name valheim-server \
  --env-file .env \
  -v ./valheim-data:/valheim-data \
  -p 2456-2458:2456-2458/udp \
  --restart unless-stopped \
  valheim-server:latest
