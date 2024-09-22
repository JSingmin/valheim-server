FROM debian:stable-slim
USER root

ENV DEBIAN_FRONTEND=noninteractive
RUN dpkg --add-architecture i386 \
    && groupadd -g "${PGID:-0}" -o valheim \
    && useradd -g "${PGID:-0}" -u "${PUID:-0}" -o --create-home valheim \
    && apt-get update \
    && apt-get -y --no-install-recommends install \
    ca-certificates \
    curl \
    lib32gcc-s1 \
    libatomic1 \
    libpulse-dev \
    libpulse0 \
    && apt-get update \
    #&& apt-get upgrade -y \
    && mkdir -p \
    /home/valheim \
    /opt/steamcmd \
    && curl -L -o /tmp/steamcmd_linux.tar.gz https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz \
    && tar xzvf /tmp/steamcmd_linux.tar.gz -C /opt/steamcmd \
    && chown -R root:root /opt/steamcmd \
    && chmod 755 \
    /opt/steamcmd/steamcmd.sh \
    /opt/steamcmd/linux32/steamcmd \
    /opt/steamcmd/linux32/steamerrorreporter \
    && su - valheim -c "/opt/steamcmd/steamcmd.sh +login anonymous +quit" \
    && mkdir -p /root/.steam/sdk64 \
    && ln -s /opt/steamcmd/linux64/steamclient.so /root/.steam/sdk64/ \
    && apt-get remove -y \
    curl \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 2456-2458/udp

USER valheim
#ENTRYPOINT ["/bin/bash"]
ENTRYPOINT ["/start.sh"]