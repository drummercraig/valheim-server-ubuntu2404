
FROM ubuntu:24.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget curl unzip rsync cron libglib2.0-0 libpulse0 \
    && rm -rf /var/lib/apt/lists/*

# Create directories
RUN mkdir -p /valheim /steamcmd /scripts /hooks /config

# Copy scripts and hooks
COPY scripts/ /scripts/
COPY hooks/ /hooks/
COPY config/settings.env /config/settings.env

# Make scripts executable
RUN chmod +x /scripts/*.sh /hooks/*.sh

EXPOSE 2456-2458/udp

CMD ["/hooks/on_start.sh"]
