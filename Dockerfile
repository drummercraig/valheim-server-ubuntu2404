FROM ubuntu:24.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget curl unzip rsync cron libglib2.0-0 libpulse0 \
    && rm -rf /var/lib/apt/lists/*

# Create directories
RUN mkdir -p /valheim /steamcmd

# Copy scripts
COPY . /valheim-server
WORKDIR /valheim-server

# Make scripts executable
RUN chmod +x *.sh

EXPOSE 2456-2458/udp

CMD ["./on_start.sh"]
