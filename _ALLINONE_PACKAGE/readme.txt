package including:
- stripper addon (linux version) + filter configs
- sm plugins: ConnectMessage (country), show right next map, knife chooser, macrodox bhop protection, mapchangeforcer, mapchooser extended, multibhops, spawntools7
- sm extentions: dhooks, cleaner (only linux, win version broken since february2014)
- kztimer database (map buttons already set for kz maps without implemented buttons)
  (database.cfg already pre-configured for kztimer)
- GeoIP database
- Spawnpoints and .nav files for several KZ&Bhop maps
- SMLib
- mapcycle.txt & gamemodes_server.txt (kz maps)

howto install:
1. download latest metamod + sourcemod version 
2. download latest kztimer snapshot (github)
3. copy all folders/files into their directory
4. server restart

files which you should configure:
csgo\mapcycle.txt (add your maps here)
csgo\gamemodes_server.txt (add your maps here)
csgo\addons\sourcemod\configs\mapchooser_extended\maps\csgo.txt (add your maps here)
csgo\cfg\sourcemod\kztimer\xxx.cfg (map type configs)
csgo\cfg\gamemode_casual_server.cfg (server config)
csgo\cfg\sourcemod\kztimer.cfg (appears after server restart)

info:
datatable warning message is harmless, just ignore it
caused by kz_prestrafe 1