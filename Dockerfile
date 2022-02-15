FROM wilkesystems/steamcmd:debian

RUN apt -y update
RUN apt -y install wget unzip python3 nano curl

RUN mkdir -p /root/.steam/sdk32/
RUN ln -s /root/.steam/steamcmd/linux32/steamclient.so /root/.steam/sdk32/steamclient.so

env IP="0.0.0.0"
env PUBLIC_IP="changeme"
env LAN="0"
env RCON_PASSWORD="changeme"
env API_KEY="changeme"
env STEAM_ACCOUNT="changeme"
env FAST_DL_URL="https://raw.githubusercontent.com/kus/csgo-modded-server-assets/master/csgo"
env MOD_URL="https://github.com/kus/csgo-modded-server/archive/master.zip"
env SERVER_PASSWORD=""
env PORT="27015"
env TICKRATE="128"
env MAXPLAYERS="32"

COPY install.sh ./

RUN chmod +x ./install.sh

CMD [ "bash", "./install.sh" ]
