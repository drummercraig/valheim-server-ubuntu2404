FROM ubuntu:24.04

# Copy settings.env into the image
COPY settings.env /valheim/settings.env

# Load environment variables from settings.env
# This converts key=value pairs into ENV instructions
RUN export $(cat /valheim/settings.env | xargs) && \
    echo "STEAMCMD_DIR=${STEAMCMD_DIR}, VALHEIM_SERVER_DIR=${VALHEIM_SERVER_DIR}"


# Install dependencies
RUN apt-get update && apt-get install -y \
    wget curl unzip rsync cron libglib2.0-0 libpulse0 \
    && rm -rf /var/lib/apt/lists/*

# Create directories
RUN mkdir -p ${STEAMCMD_DIR} ${VALHEIM_SERVER_DIR}

# Copy scripts
COPY . /valheim-server
WORKDIR /valheim-server

# Make scripts executable
RUN chmod +x *.sh

EXPOSE 2456-2458/udp

CMD ["./on_start_cf.sh"]
