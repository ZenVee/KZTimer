https://forums.alliedmods.net/showthread.php?t=223274
Changelog
=======

v1.1
- replay bot: replaced hk2000 with usp silencer
- removed "usp is slower than knife.." msg when kz_prestrafe is enabled
 
v1.11
- added kz_fps_check 1 to settings enforcer (0 < fps_max <= 300) - 10sec warning on spawn
- added height to bhop, multibhop, dropbhop & wj jumpstats msg's
- new db table: playeroptions2 replaces playeroptions
- new db table: playerjumpstats2 replaces playerjumpstats (added ljheight, wjheight, bhopheight, dropbhopheight, multibhopheight)
- detailed player view (top 100 players & jump top's)
- optimized default jumpstats values
- optimized map cfgs (cfg/sourcemod/kztimer/..)
- added player option jump penalty
- added server cvar kz_force_jump_penalty
- fixed undo abuse during a challenge
- integrated macrodox bhop anti cheat (instant ban)
- auto-removing of records from banned players
- added kz_anticheat_ban_duration (hours)
- added !bhopcheck <name>

v1.12
- minor bug fixes
- code optimization

v1.13
- player names of jumpstats records and player times refer to the profile name 
- minor bug fixes
- code optimization

v1.14
- overhauled calculation of player rankings
- fixed several minor bugs
