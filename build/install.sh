#!/usr/bin/bash

# Variables
IP="0.0.0.0"

#echo "Downloading any updates for CS:GO..."
steamcmd +force_install_dir /home/csgo \
  +login anonymous \
  +app_update 740 \
  +quit

mkdir /home/csgo/csgo/warmod/ -p

cd /home/csgo/csgo/warmod/ && python3 -m http.server 8560 </dev/null &>/dev/null &

cd /home/

echo "Downloading mod files..."
wget --quiet https://github.com/kus/csgo-modded-server/archive/master.zip
unzip -o -qq master.zip
cp -rlf csgo-modded-server-master/csgo/ /home/csgo/
rm -r csgo-modded-server-master master.zip

echo "Dynamically writing /home/csgo/csgo/cfg/env.cfg"
echo "rcon_password						\"$RCON_PASSWORD\"" > /home/csgo/csgo/cfg/env.cfg
echo "sv_setsteamaccount					\"$STEAM_ACCOUNT\"			// Required for online https://steamcommunity.com/dev/managegameservers" >> /home/csgo/csgo/cfg/env.cfg
if [ -z "$SERVER_PASSWORD" ]; then
	echo "sv_password							\"\"" >> /home/csgo/csgo/cfg/env.cfg
else
	echo "sv_password							\"$SERVER_PASSWORD\"" >> /home/csgo/csgo/cfg/env.cfg
fi
if [ "$LAN" = "1" ]; then
	echo "sv_lan								1" >> /home/csgo/csgo/cfg/env.cfg
else
	echo "sv_lan								0" >> /home/csgo/csgo/cfg/env.cfg
fi
echo "sv_downloadurl						\"$FAST_DL_URL\"			// Fast download (custom files uploaded to web server)" >> /home/csgo/csgo/cfg/env.cfg
echo "sv_allowupload						0" >> /home/csgo/csgo/cfg/env.cfg
if [ -z "$FAST_DL_URL" ]; then
	# No Fast DL
	echo "sv_allowdownload					1			// If using Fast download change to 0" >> /home/csgo/csgo/cfg/env.cfg
else
	# Has Fast DL
	echo "sv_allowdownload					0			// If using Fast download change to 0" >> /home/csgo/csgo/cfg/env.cfg
fi
echo "" >> /home/csgo/csgo/cfg/env.cfg
echo "echo \"env.cfg executed\"" >> /home/csgo/csgo/cfg/env.cfg

# Uncomment below for custom admins
echo "Dynamically writing /home/csgo/csgo/addons/sourcemod/configs/admins_simple.ini"
echo "\"STEAM_0:1:58154498\"	\"9:z\"	// blast." > /home/csgo/csgo/addons/sourcemod/configs/admins_simple.ini
echo "\"STEAM_0:1:155831497\"	\"8:z\"	// Maial" >> /home/csgo/csgo/addons/sourcemod/configs/admins_simple.ini
# echo "\"STEAM_0:0:3\"	\"8:z\"	// Third user" >> /home/csgo/csgo/addons/sourcemod/configs/admins_simple.ini

cd /home/csgo/csgo

cp gamerulescvars.txt.example gamerulescvars.txt
cp gamemodes_server.txt.example gamemodes_server.txt

cd /home/csgo

curl --silent --output "automate.sh" "https://raw.githubusercontent.com/kus/csgo-modded-server-assets/master/automate.sh" && chmod +x automate.sh && bash automate.sh

echo "Starting server"
./srcds_run \
    -console \
    -usercon \
    -autoupdate \
    -game csgo \
    -tickrate $TICKRATE \
    -port $PORT \
    -maxplayers_override $MAXPLAYERS \
    -authkey $API_KEY \
    +game_type 0 \
    +game_mode 0 \
    +mapgroup mg_active \
    +map de_dust2 \
    +ip $IP
