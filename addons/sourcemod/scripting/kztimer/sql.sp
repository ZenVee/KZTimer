//TABLE CHALLENGE
new String:sql_createChallenges[] 				= "CREATE TABLE IF NOT EXISTS challenges (steamid VARCHAR(32), steamid2 VARCHAR(32), bet INT(12), cp_allowed INT(12), map VARCHAR(32), date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP);";
new String:sql_insertChallenges[] 				= "INSERT INTO challenges (steamid, steamid2, bet, map, cp_allowed) VALUES('%s', '%s','%i','%s','%i');";
new String:sql_selectChallenges[] 				= "SELECT steamid, steamid2, bet, cp_allowed, map FROM challenges where steamid = '%s' OR steamid2 ='%s'";
new String:sql_selectChallengesCompare[] 		= "SELECT steamid, steamid2, bet FROM challenges where (steamid = '%s' AND steamid2 ='%s') OR (steamid = '%s' AND steamid2 ='%s')";

//TABLE PLAYEROPTIONS
new String:sql_createPlayerOptions[] 			= "CREATE TABLE IF NOT EXISTS playeroptions2 (steamid VARCHAR(32), colorchat INT(12) DEFAULT '1', speedmeter INT(12) DEFAULT '0', climbersmenu_sounds INT(12) DEFAULT '1', quake_sounds INT(12) DEFAULT '1', autobhop INT(12) DEFAULT '0', shownames INT(12) DEFAULT '1', goto INT(12) DEFAULT '1', strafesync INT(12) DEFAULT '0', showtime INT(12) DEFAULT '1', hideplayers INT(12) DEFAULT '0', showspecs INT(12) DEFAULT '1', cpmessage INT(12) DEFAULT '0', adv_menu INT(12) DEFAULT '0', knife VARCHAR(32) DEFAULT 'weapon_knife', jumppenalty INT(12) DEFAULT '0', new1 INT(12) DEFAULT '0', new2 INT(12) DEFAULT '0', new3 INT(12) DEFAULT '0', PRIMARY KEY(steamid));";
new String:sql_insertPlayerOptions[] 			= "INSERT INTO playeroptions2 (steamid, colorchat, speedmeter, climbersmenu_sounds, quake_sounds, autobhop, shownames, goto, strafesync, showtime, hideplayers, showspecs, cpmessage, adv_menu, knife, jumppenalty, new1, new2, new3) VALUES('%s', '%i', '%i', '%i', '%i', '%i', '%i', '%i', '%i', '%i', '%i', '%i', '%i', '%i', '%s', '%i', '%i', '%i', '%i');";
new String:sql_selectPlayerOptions[] 			= "SELECT colorchat, speedmeter, climbersmenu_sounds, quake_sounds, autobhop, shownames, goto, strafesync, showtime, hideplayers, showspecs, cpmessage, adv_menu, knife, jumppenalty, new1, new2, new3 FROM playeroptions2 where steamid = '%s'";
new String:sql_updatePlayerOptions[]				= "UPDATE playeroptions2 SET colorchat ='%i', speedmeter ='%i', climbersmenu_sounds ='%i', quake_sounds ='%i', autobhop ='%i', shownames ='%i', goto ='%i', strafesync ='%i', showtime ='%i', hideplayers ='%i', showspecs ='%i', cpmessage ='%i', adv_menu ='%i', knife ='%s', jumppenalty ='%i', new1 = '%i', new2 = '%i', new3 = '%i' where steamid = '%s'";

//TABLE PLAYERRANK
new String:sql_createPlayerRank[]					= "CREATE TABLE IF NOT EXISTS playerrank (steamid VARCHAR(32), name VARCHAR(32), country VARCHAR(32), points INT(12)  DEFAULT '0', winratio INT(12)  DEFAULT '0', pointsratio INT(12)  DEFAULT '0',finishedmaps INT(12) DEFAULT '0', multiplier INT(12) DEFAULT '0', finishedmapstp INT(12) DEFAULT '0', finishedmapspro INT(12) DEFAULT '0', PRIMARY KEY(steamid));";
new String:sql_insertPlayerRank[] 				= "INSERT INTO playerrank (steamid, name, country) VALUES('%s', '%s', '%s');";
new String:sql_updatePlayerRankPoints[]			= "UPDATE playerrank SET name ='%s', points ='%i', finishedmapstp ='%i', finishedmapspro='%i' where steamid='%s'";
new String:sql_updatePlayerRankPoints2[]		= "UPDATE playerrank SET name ='%s', points ='%i', finishedmapstp ='%i', finishedmapspro='%i',winratio = '%i',pointsratio = '%i', country ='%s' where steamid='%s'";
new String:sql_updatePlayerRank[]					= "UPDATE playerrank SET finishedmaps ='%i', finishedmapstp ='%i', finishedmapspro='%i', multiplier ='%i',winratio = '%i',pointsratio = '%i'  where steamid='%s'";
new String:sql_updatePlayerRankChallenge[]		= "UPDATE playerrank SET multiplier ='%i',winratio = '%i',pointsratio = '%i'  where steamid='%s'";
new String:sql_selectPlayerRankAll[] 			= "SELECT name, steamid FROM playerrank where name like '%s'";

new String:sql_selectTopPlayers[]					= "SELECT name, points, finishedmapspro, finishedmapstp, steamid FROM playerrank ORDER BY points DESC LIMIT 100";
new String:sql_selectTopChallengers[]			= "SELECT name, winratio, pointsratio, steamid FROM playerrank ORDER BY pointsratio DESC LIMIT 5";
new String:sql_selectRankedPlayer[]				= "SELECT steamid, name, points, finishedmapstp, finishedmapspro, multiplier, winratio, pointsratio, country from playerrank where steamid='%s'";
new String:sql_selectRankedPlayersRank[]		= "SELECT name FROM playerrank WHERE points >= (SELECT points FROM playerrank WHERE steamid = '%s') ORDER BY points";
new String:sql_selectRankedPlayers[]				= "SELECT steamid, name from playerrank where points > 0";
new String:sql_CountRankedPlayers[] 				= "SELECT COUNT(steamid) FROM playerrank";
new String:sql_CountRankedPlayers2[] 			= "SELECT COUNT(steamid) FROM playerrank where points > 0";

//TABLE PLAYERTIMES
new String:sql_createPlayertimes[] 				= "CREATE TABLE IF NOT EXISTS playertimes (steamid VARCHAR(32), mapname VARCHAR(32), name VARCHAR(32), teleports INT(12) DEFAULT '-1', runtime FLOAT NOT NULL DEFAULT '-1.0', runtimepro FLOAT NOT NULL DEFAULT '-1.0',teleports_pro INT(12) DEFAULT '0', PRIMARY KEY(steamid,mapname));";
new String:sql_insertPlayer[] 						= "INSERT INTO playertimes (steamid, mapname, name) VALUES('%s', '%s', '%s');";
new String:sql_insertPlayerTp[] 					= "INSERT INTO playertimes (steamid, mapname, name,runtime, teleports) VALUES('%s', '%s', '%s', '%f', '%i');";
new String:sql_insertPlayerPro[] 					= "INSERT INTO playertimes (steamid, mapname, name,runtimepro) VALUES('%s', '%s', '%s', '%f');";
new String:sql_updateRecord[] 						= "UPDATE playertimes SET name = '%s', teleports = '%i', runtime = '%f' WHERE steamid = '%s' AND mapname = '%s';"; 
new String:sql_updateRecordPro[]					= "UPDATE playertimes SET name = '%s', runtimepro = '%f' WHERE steamid = '%s' AND mapname = '%s';"; 
new String:sql_deletePlayer[] 						= "DELETE FROM playertimes where steamid = '%s' AND mapname= '%s' AND runtimepro = -1.0 AND runtime = -1.0";
new String:sql_deleteDeadPlayer[] 				= "DELETE FROM playertimes where runtimepro = -1.0 AND runtime = -1.0;";
new String:sql_CountFinishedMapsTP[] 			= "SELECT mapname FROM playertimes where steamid='%s' AND runtime > -1.0";
new String:sql_CountFinishedMapsPro[] 			= "SELECT mapname FROM playertimes where steamid='%s' AND runtimepro > -1.0";
new String:sql_selectPlayer[] 						= "SELECT steamid FROM playertimes WHERE steamid = '%s' AND mapname = '%s';";
new String:sql_selectRecordTp[] 					= "SELECT mapname, steamid, name, runtime, teleports  FROM playertimes WHERE steamid = '%s' AND mapname = '%s' AND runtime > -1.0;";
new String:sql_selectProRecord[] 					= "SELECT mapname, steamid, name, runtimepro FROM playertimes WHERE steamid = '%s' AND mapname = '%s' AND runtimepro > -1.0;";
new String:sql_selectRecord[] 						= "SELECT steamid FROM playertimes WHERE steamid = '%s' AND mapname = '%s' AND (runtime  > -1.0 OR runtimepro  > -1.0)";
new String:sql_selectMapRecordCP[] 				= "SELECT runtime, name, teleports FROM playertimes WHERE mapname = '%s' AND runtime  > -1.0 ORDER BY runtime ASC LIMIT 1"; 
new String:sql_selectMapRecordPro[] 				= "SELECT runtimepro, name FROM playertimes WHERE mapname = '%s' AND runtimepro  > -1.0 ORDER BY runtimepro ASC LIMIT 1"; 
new String:sql_selectPersonalRecords[] 			= "SELECT mapname, steamid, name, runtime, runtimepro, teleports  FROM playertimes WHERE steamid = '%s' AND mapname = '%s' AND (runtime  > -1.0 OR runtimepro  > -1.0)"; 
new String:sql_selectPersonalAllRecords[] 		= "SELECT name, steamid, mapname, runtime as overall, teleports AS tp FROM playertimes WHERE steamid = '%s' AND runtime > -1.0 AND teleports >= 0 UNION SELECT name, steamid, mapname, runtimepro as overall, teleports_pro AS tp FROM playertimes WHERE steamid = '%s' AND runtimepro > -1.0 ORDER BY mapname ASC";
new String:sql_selectTPClimbers[] 				= "SELECT name, runtime, teleports, steamid FROM playertimes WHERE mapname = '%s' AND runtime > -1.0 AND teleports >= 0 ORDER BY runtime ASC LIMIT 20";
new String:sql_selectProClimbers[] 				= "SELECT name, runtimepro, steamid FROM playertimes WHERE mapname = '%s' AND runtimepro > -1.0 ORDER BY runtimepro ASC LIMIT 20";
new String:sql_selectTopClimbers[] 				= "SELECT steamid, name, runtime as overall, teleports AS tp FROM playertimes WHERE mapname = '%s' AND runtime > -1.0 AND teleports >= 0 UNION SELECT steamid, name, runtimepro as overall, teleports_pro AS tp FROM playertimes WHERE mapname = '%s' AND runtimepro > -1.0 ORDER BY overall ASC LIMIT 100";
new String:sql_selectPlayerCount[] 				= "SELECT name FROM playertimes WHERE mapname = '%s' AND runtime  > -1.0;";
new String:sql_selectPlayerProCount[] 			= "SELECT name FROM playertimes WHERE mapname = '%s' AND runtimepro  > -1.0;";
new String:sql_selectPlayerRankTime[] 			= "SELECT name,teleports,mapname FROM playertimes WHERE runtime <= (SELECT runtime FROM playertimes WHERE steamid = '%s' AND mapname = '%s' AND runtime > -1.0) AND mapname = '%s' AND runtime  > -1.0 ORDER BY runtime;";
new String:sql_selectPlayerRankProTime[] 		= "SELECT name,teleports_pro,mapname FROM playertimes WHERE runtimepro <= (SELECT runtimepro FROM playertimes WHERE steamid = '%s' AND mapname = '%s' AND runtimepro > -1.0) AND mapname = '%s' AND runtimepro > -1.0 ORDER BY runtimepro;";
new String:sql_selectProRecordHolders[] 		= "SELECT y.steamid, COUNT(*) AS rekorde FROM (SELECT s.steamid FROM playertimes s INNER JOIN (SELECT mapname, MIN(runtimepro) AS runtimepro FROM playertimes where runtimepro > -1.0 GROUP BY mapname) x ON s.mapname = x.mapname AND s.runtimepro = x.runtimepro) y GROUP BY y.steamid ORDER BY rekorde DESC , y.steamid LIMIT 5;";
new String:sql_selectTpRecordHolders[] 			= "SELECT y.steamid, COUNT(*) AS rekorde FROM (SELECT s.steamid FROM playertimes s INNER JOIN (SELECT mapname, MIN(runtime) AS runtime FROM playertimes where runtime > -1.0 GROUP BY mapname) x ON s.mapname = x.mapname AND s.runtime = x.runtime) y GROUP BY y.steamid ORDER BY rekorde DESC , y.steamid LIMIT 5;";
new String:sql_selectTpRecordCount[] 			= "SELECT y.steamid, COUNT(*) AS rekorde FROM (SELECT s.steamid FROM playertimes s INNER JOIN (SELECT mapname, MIN(runtime) AS runtime FROM playertimes where runtime > -1.0  GROUP BY mapname) x ON s.mapname = x.mapname AND s.runtime = x.runtime) y where y.steamid = '%s' GROUP BY y.steamid ORDER BY rekorde DESC , y.steamid;";
new String:sql_selectProRecordCount[] 			= "SELECT y.steamid, COUNT(*) AS rekorde FROM (SELECT s.steamid FROM playertimes s INNER JOIN (SELECT mapname, MIN(runtimepro) AS runtimepro FROM playertimes where runtimepro > -1.0  GROUP BY mapname) x ON s.mapname = x.mapname AND s.runtimepro = x.runtimepro) y where y.steamid = '%s' GROUP BY y.steamid ORDER BY rekorde DESC , y.steamid;";

//TABLE PLAYERTMP
new String:sql_createPlayertmp[] 					= "CREATE TABLE IF NOT EXISTS playertmp (steamid VARCHAR(32), mapname VARCHAR(32), cords1 FLOAT NOT NULL DEFAULT '-1.0', cords2 FLOAT NOT NULL DEFAULT '-1.0', cords3 FLOAT NOT NULL DEFAULT '-1.0', angle1 FLOAT NOT NULL DEFAULT '-1.0',angle2 FLOAT NOT NULL DEFAULT '-1.0',angle3 FLOAT NOT NULL DEFAULT '-1.0', teleports INT(12) DEFAULT '-1.0', checkpoints INT(12) DEFAULT '-1.0', runtimeTmp FLOAT NOT NULL DEFAULT '-1.0', PRIMARY KEY(steamid,mapname));";
new String:sql_insertPlayerTmp[]  				= "INSERT INTO playertmp (steamid, mapname) VALUES ('%s', '%s');";
new String:sql_updateRunTmp[] 						= "UPDATE playertmp SET cords1 = '%f', cords2 = '%f', cords3 = '%f', angle1 = '%f', angle2 = '%f', angle3 = '%f', teleports = '%i', checkpoints = '%i', runtimeTmp = '%f' where steamid = '%s' and mapname ='%s';";
new String:sql_updatePlayerTmp[] 					= "UPDATE playertmp SET mapname ='%s' WHERE steamid = '%s';";
new String:sql_deletePlayerTmp[] 					= "DELETE FROM playertmp where steamid = '%s' AND mapname= '%s';";
new String:sql_deleteDeadPlayerTmp[] 			= "DELETE FROM playertmp where runtimeTmp = -1.0;";
new String:sql_selectLastRun[] 					= "SELECT cords1,cords2,cords3, angle1, angle2, angle3, teleports, checkpoints, runtimeTmp FROM playertmp WHERE steamid = '%s' AND mapname = '%s';";
new String:sql_selectPlayerTmp[] 					= "SELECT steamid, mapname FROM playertmp WHERE steamid = '%s';";

//TABLE JUMMPSTATS
new String:sql_createPlayerjumpstats[] 			= "CREATE TABLE IF NOT EXISTS playerjumpstats2 (steamid VARCHAR(32), name VARCHAR(32), multibhoprecord FLOAT NOT NULL DEFAULT '-1.0',  multibhoppre FLOAT NOT NULL DEFAULT '-1.0', multibhopmax FLOAT NOT NULL DEFAULT '-1.0', multibhopstrafes INT(12),multibhopcount INT(12),multibhopsync INT(12), multibhopheight FLOAT NOT NULL DEFAULT '-1.0', bhoprecord FLOAT NOT NULL DEFAULT '-1.0',  bhoppre FLOAT NOT NULL DEFAULT '-1.0', bhopmax FLOAT NOT NULL DEFAULT '-1.0', bhopstrafes INT(12),bhopsync INT(12), bhopheight FLOAT NOT NULL DEFAULT '-1.0', ljrecord FLOAT NOT NULL DEFAULT '-1.0', ljpre FLOAT NOT NULL DEFAULT '-1.0', ljmax FLOAT NOT NULL DEFAULT '-1.0', ljstrafes INT(12),ljsync INT(12), ljheight FLOAT NOT NULL DEFAULT '-1.0', dropbhoprecord FLOAT NOT NULL DEFAULT '-1.0',  dropbhoppre FLOAT NOT NULL DEFAULT '-1.0', dropbhopmax FLOAT NOT NULL DEFAULT '-1.0', dropbhopstrafes INT(12),dropbhopsync INT(12), dropbhopheight FLOAT NOT NULL DEFAULT '-1.0', wjrecord FLOAT NOT NULL DEFAULT '-1.0', wjpre FLOAT NOT NULL DEFAULT '-1.0', wjmax FLOAT NOT NULL DEFAULT '-1.0', wjstrafes INT(12),wjsync INT(12), wjheight FLOAT NOT NULL DEFAULT '-1.0', standupbhoprecord FLOAT NOT NULL DEFAULT '-1.0',  standupbhoppre FLOAT NOT NULL DEFAULT '-1.0', standupbhopmax FLOAT NOT NULL DEFAULT '-1.0', standupbhopstrafes INT(12),standupbhopcount INT(12),standupbhopsync INT(12), standupbhopheight FLOAT NOT NULL DEFAULT '-1.0', dropstandupbhoprecord FLOAT NOT NULL DEFAULT '-1.0',  dropstandupbhoppre FLOAT NOT NULL DEFAULT '-1.0', dropstandupbhopmax FLOAT NOT NULL DEFAULT '-1.0', dropstandupbhopstrafes INT(12), dropstandupbhopcount INT(12), dropstandupbhopsync INT(12), dropstandupbhopheight FLOAT NOT NULL DEFAULT '-1.0', ladderjumprecord FLOAT NOT NULL DEFAULT '-1.0',  ladderjumppre FLOAT NOT NULL DEFAULT '-1.0', ladderjumpmax FLOAT NOT NULL DEFAULT '-1.0', ladderjumpstrafes INT(12), ladderjumpcount INT(12), ladderjumpsync INT(12), ladderjumpheight FLOAT NOT NULL DEFAULT '-1.0', ladderbhoprecord FLOAT NOT NULL DEFAULT '-1.0',  ladderbhoppre FLOAT NOT NULL DEFAULT '-1.0', ladderbhopmax FLOAT NOT NULL DEFAULT '-1.0', ladderbhopstrafes INT(12), ladderbhopcount INT(12), ladderbhopsync INT(12), ladderbhopheight FLOAT NOT NULL DEFAULT '-1.0',  PRIMARY KEY(steamid));";
new String:sql_insertPlayerJumpBhop[] 			= "INSERT INTO playerjumpstats2 (steamid, name, bhoprecord, bhoppre, bhopmax, bhopstrafes, bhopsync, bhopheight) VALUES('%s', '%s', '%f', '%f', '%f', '%i', '%i', '%f');";
new String:sql_insertPlayerJumpLj[] 				= "INSERT INTO playerjumpstats2 (steamid, name, ljrecord, ljpre, ljmax, ljstrafes, ljsync, ljheight) VALUES('%s', '%s', '%f', '%f', '%f', '%i', '%i', '%f');";
new String:sql_insertPlayerJumpMultiBhop[] 	= "INSERT INTO playerjumpstats2 (steamid, name, multibhoprecord, multibhoppre, multibhopmax, multibhopstrafes, multibhopcount, multibhopsync, multibhopheight) VALUES('%s', '%s', '%f', '%f', '%f', '%i', '%i', '%i', '%f');";
new String:sql_insertPlayerJumpDropBhop[] 		= "INSERT INTO playerjumpstats2 (steamid, name, dropbhoprecord, dropbhoppre, dropbhopmax, dropbhopstrafes, dropbhopsync, dropbhopheight) VALUES('%s', '%s', '%f', '%f', '%f', '%i', '%i', '%f');";
new String:sql_insertPlayerJumpWJ[] 				= "INSERT INTO playerjumpstats2 (steamid, name, wjrecord, wjpre, wjmax, wjstrafes, wjsync, wjheight) VALUES('%s', '%s', '%f', '%f', '%f', '%i', '%i', '%f');";

new String:sql_updateLj[] 							= "UPDATE playerjumpstats2 SET name='%s', ljrecord ='%f', ljpre ='%f', ljmax ='%f', ljstrafes='%i', ljsync='%i', ljheight='%f' WHERE steamid = '%s';";
new String:sql_updateBhop[] 						= "UPDATE playerjumpstats2 SET name='%s', bhoprecord ='%f', bhoppre ='%f', bhopmax ='%f', bhopstrafes='%i', bhopsync='%i', bhopheight='%f' WHERE steamid = '%s';";
new String:sql_updateMultiBhop[] 					= "UPDATE playerjumpstats2 SET name='%s', multibhoprecord ='%f', multibhoppre ='%f', multibhopmax ='%f', multibhopstrafes='%i', multibhopcount='%i', multibhopsync='%i', multibhopheight='%f' WHERE steamid = '%s';";
new String:sql_updateDropBhop[] 					= "UPDATE playerjumpstats2 SET name='%s', dropbhoprecord ='%f', dropbhoppre ='%f', dropbhopmax ='%f', dropbhopstrafes='%i', dropbhopsync='%i', dropbhopheight='%f' WHERE steamid = '%s';";
new String:sql_updateWJ[] 							= "UPDATE playerjumpstats2 SET name='%s', wjrecord ='%f', wjpre ='%f', wjmax ='%f', wjstrafes='%i', wjsync='%i', wjheight='%f' WHERE steamid = '%s';";

new String:sql_selectPlayerJumpTopLJ[] 			= "SELECT name, ljrecord,ljstrafes, steamid FROM playerjumpstats2 WHERE ljrecord > -1.0 ORDER BY ljrecord DESC LIMIT 20";
new String:sql_selectPlayerJumpTopBhop[] 		= "SELECT name, bhoprecord,bhopstrafes, steamid FROM playerjumpstats2 WHERE bhoprecord > -1.0 ORDER BY bhoprecord DESC LIMIT 20";
new String:sql_selectPlayerJumpTopMultiBhop[] 	= "SELECT name, multibhoprecord,multibhopstrafes, steamid FROM playerjumpstats2 WHERE multibhoprecord > -1.0 ORDER BY multibhoprecord DESC LIMIT 20";
new String:sql_selectPlayerJumpTopDropBhop[] 	= "SELECT name, dropbhoprecord,dropbhopstrafes, steamid FROM playerjumpstats2 WHERE dropbhoprecord > -1.0 ORDER BY dropbhoprecord DESC LIMIT 20";
new String:sql_selectPlayerJumpTopWJ[] 			= "SELECT name, wjrecord,wjstrafes, steamid FROM playerjumpstats2 WHERE wjrecord > -1.0 ORDER BY wjrecord DESC LIMIT 20";

new String:sql_selectPlayerJumpLJ[] 				= "SELECT steamid, name, ljrecord FROM playerjumpstats2 WHERE steamid = '%s';";
new String:sql_selectPlayerJumpBhop[] 			= "SELECT steamid, name, bhoprecord FROM playerjumpstats2 WHERE steamid = '%s';";
new String:sql_selectPlayerJumpMultiBhop[] 	= "SELECT steamid, name, multibhoprecord FROM playerjumpstats2 WHERE steamid = '%s';";
new String:sql_selectPlayerJumpWJ[] 				= "SELECT steamid, name, wjrecord FROM playerjumpstats2 WHERE steamid = '%s';";
new String:sql_selectPlayerJumpDropBhop[] 		= "SELECT steamid, name, dropbhoprecord FROM playerjumpstats2 WHERE steamid = '%s';";

new String:sql_selectJumpStats[] 					= "SELECT steamid, name, bhoprecord,bhoppre,bhopmax,bhopstrafes,bhopsync, ljrecord, ljpre, ljmax, ljstrafes,ljsync, multibhoprecord,multibhoppre,multibhopmax,multibhopstrafes,multibhopcount,multibhopsync, wjrecord, wjpre, wjmax, wjstrafes, wjsync, dropbhoprecord, dropbhoppre, dropbhopmax, dropbhopstrafes, dropbhopsync, ljheight, bhopheight, multibhopheight, dropbhopheight, wjheight FROM playerjumpstats2 WHERE (wjrecord > -1.0 OR dropbhoprecord > -1.0 OR ljrecord > -1.0 OR bhoprecord > -1.0 OR multibhoprecord > -1.0) AND steamid = '%s';";
new String:sql_selectPlayerRankMultiBhop[]		= "SELECT name FROM playerjumpstats2 WHERE multibhoprecord >= (SELECT multibhoprecord FROM playerjumpstats2 WHERE steamid = '%s' AND multibhoprecord > -1.0) AND multibhoprecord  > -1.0 ORDER BY multibhoprecord;";
new String:sql_selectPlayerRankLj[] 				= "SELECT name FROM playerjumpstats2 WHERE ljrecord >= (SELECT ljrecord FROM playerjumpstats2 WHERE steamid = '%s' AND ljrecord > -1.0) AND ljrecord  > -1.0 ORDER BY ljrecord;";
new String:sql_selectPlayerRankBhop[] 			= "SELECT name FROM playerjumpstats2 WHERE bhoprecord >= (SELECT bhoprecord FROM playerjumpstats2 WHERE steamid = '%s' AND bhoprecord > -1.0) AND bhoprecord  > -1.0 ORDER BY bhoprecord;";
new String:sql_selectPlayerRankWJ[] 				= "SELECT name FROM playerjumpstats2 WHERE wjrecord >= (SELECT wjrecord FROM playerjumpstats2 WHERE steamid = '%s' AND wjrecord > -1.0) AND wjrecord  > -1.0 ORDER BY wjrecord;";
new String:sql_selectPlayerRankDropBhop[] 		= "SELECT name FROM playerjumpstats2 WHERE dropbhoprecord >= (SELECT dropbhoprecord FROM playerjumpstats2 WHERE steamid = '%s' AND dropbhoprecord > -1.0) AND dropbhoprecord  > -1.0 ORDER BY dropbhoprecord;";

// TABLE MAP BUTTONS
new String:sql_createMapButtons[] 				= "CREATE TABLE IF NOT EXISTS MapButtons (mapname VARCHAR(32), cords1Start FLOAT NOT NULL DEFAULT '-1.0', cords2Start FLOAT NOT NULL DEFAULT '-1.0', cords3Start FLOAT NOT NULL DEFAULT '-1.0', cords1End FLOAT NOT NULL DEFAULT '-1.0', cords2End FLOAT NOT NULL DEFAULT '-1.0', cords3End FLOAT NOT NULL DEFAULT '-1.0', ang_start FLOAT NOT NULL DEFAULT '-1.0', ang_end FLOAT NOT NULL DEFAULT '-1.0');";
new String:sql_deleteMapButtons[] 				= "DELETE FROM MapButtons where mapname= '%s';";
new String:sql_insertMapButtons[] 				= "INSERT INTO MapButtons (mapname, cords1Start, cords2Start,cords3Start,cords1End,cords2End,cords3End,ang_start,ang_end) VALUES('%s', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f');";
new String:sql_selectMapButtons[] 				= "SELECT cords1Start,cords2Start,cords3Start,cords1End,cords2End,cords3End,ang_start,ang_end FROM MapButtons WHERE mapname = '%s';";
new String:sql_updateMapButtonsStart[] 			= "UPDATE MapButtons SET cords1Start ='%f', cords2Start ='%f', cords3Start ='%f', ang_start = '%f' WHERE mapname = '%s';";
new String:sql_updateMapButtonsEnd[]				= "UPDATE MapButtons SET cords1End ='%f', cords2End ='%f', cords3End ='%f', ang_end = '%f' WHERE mapname = '%s';";


// GLOBAL TABLE
new String:sqlglobal_selectGlobalRecord[] 		= "SELECT name, runtime, teleports FROM player WHERE mapname = '%s' ORDER BY runtime ASC LIMIT 5";
new String:sqlglobal_selectGlobalTop[] 			= "SELECT name, runtime, teleports FROM player WHERE mapname = '%s' ORDER BY runtime ASC LIMIT 5";
new String:sqlglobal_selectTop5Players[] 		= "SELECT runtime, steamid FROM player WHERE mapname = '%s' ORDER BY runtime ASC LIMIT 5";
new String:sqlglobal_selectPlayers[] 			= "SELECT runtime, steamid, mapname FROM player WHERE mapname = '%s' ORDER BY runtime ASC";
new String:sqlglobal_deletePlayer[] 				= "DELETE FROM player WHERE steamid = '%s' AND mapname = '%s'"; 
new String:sqlglobal_insertPlayer[] 				= "INSERT INTO player (steamid, mapname, name, runtime, teleports) VALUES('%s', '%s', '%s', '%f', '%i');";
new String:sqlglobal_updatePlayer[] 				= "UPDATE player SET name = '%s', runtime = '%f', teleports = '%i' WHERE steamid = '%s' AND mapname = '%s';"; 
new String:sqlglobal_selectGlobalRecord128[] 		= "SELECT name, runtime, teleports FROM player128 WHERE mapname = '%s' ORDER BY runtime ASC LIMIT 5";
new String:sqlglobal_selectGlobalTop128[] 			= "SELECT name, runtime, teleports FROM player128 WHERE mapname = '%s' ORDER BY runtime ASC LIMIT 5";
new String:sqlglobal_selectTop5Players128[] 		= "SELECT runtime, steamid FROM player128 WHERE mapname = '%s' ORDER BY runtime ASC LIMIT 5";
new String:sqlglobal_selectPlayers128[] 			= "SELECT runtime, steamid, mapname FROM player128 WHERE mapname = '%s' ORDER BY runtime ASC";
new String:sqlglobal_deletePlayer128[] 				= "DELETE FROM player128 WHERE steamid = '%s' AND mapname = '%s'"; 
new String:sqlglobal_insertPlayer128[] 				= "INSERT INTO player128 (steamid, mapname, name, runtime, teleports) VALUES('%s', '%s', '%s', '%f', '%i');";
new String:sqlglobal_updatePlayer128[] 				= "UPDATE player128 SET name = '%s', runtime = '%f', teleports = '%i' WHERE steamid = '%s' AND mapname = '%s';";
new String:sqlglobal_selectFilesize[] 				= "SELECT filesize FROM maplist where mapname = '%s'";
new String:sqlglobal_insertFilesize[] 				= "INSERT INTO maplist (mapname, filesize) VALUES('%s', '%i');";
new String:sqlglobal_insertBan[] 					= "INSERT INTO banlist (steamid, player) VALUES('%s', '%s');";

// ADMIN 
new String:sqlite_dropMap[] 					= "DROP TABLE map; VACCUM";
new String:sql_dropMap[] 						= "DROP TABLE map;";
new String:sqlite_dropPlayer[] 				= "DROP TABLE playertimes; VACCUM";
new String:sql_dropPlayer[] 					= "DROP TABLE playertimes;";
new String:sql_dropPlayerRank[] 				= "DROP TABLE playerrank;";
new String:sqlite_dropPlayerRank[] 			= "DROP TABLE playerrank; VACCUM";
new String:sqlite_dropPlayerJump[] 			= "DROP TABLE playerjumpstats; VACCUM";
new String:sql_dropPlayerJump[] 				= "DROP TABLE playerjumpstats;";
new String:sql_resetRecords[] 				= "UPDATE playertimes SET runtime = '-1.0', runtimepro = '-1.0' WHERE steamid LIKE '%s'";
new String:sql_resetRecords2[] 				= "UPDATE playertimes SET runtime = '-1.0', runtimepro = '-1.0' WHERE steamid LIKE '%s' AND mapname LIKE '%s';";
new String:sql_resetMapRecords[] 			= "DELETE FROM playertimes WHERE mapname LIKE '%s'";
new String:sql_resetBhopRecord[] 			= "UPDATE playerjumpstats SET bhoprecord = '-1.0' WHERE steamid LIKE '%s';";   
new String:sql_resetDropBhopRecord[] 		= "UPDATE playerjumpstats SET dropbhoprecord = '-1.0' WHERE steamid LIKE '%s';";   
new String:sql_resetWJRecord[] 				= "UPDATE playerjumpstats SET wjrecord = '-1.0' WHERE steamid LIKE '%s';";   
new String:sql_resetLjRecord[] 				= "UPDATE playerjumpstats SET ljrecord = '-1.0' WHERE steamid LIKE '%s';";  
new String:sql_resetMultiBhopRecord[] 		= "UPDATE playerjumpstats SET multibhoprecord = '-1.0' WHERE steamid LIKE '%s';";  
new String:sql_resetCheat1[] 					= "DELETE FROM playertimes WHERE steamid LIKE '%s'";
new String:sql_resetCheat2[] 					= "DELETE FROM playerrank WHERE steamid LIKE '%s'";
new String:sql_resetCheat3[] 					= "UPDATE playerjumpstats SET bhoprecord = '-1.0', multibhoprecord = '-1.0', ljrecord = '-1.0',wjrecord = '-1.0', dropbhoprecord = '-1.0' WHERE steamid LIKE '%s';"; 


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public db_DeleteCheater(client, String:steamid[32])
{
	decl String:szQuery[255];
	decl String:szsteamid[32*2+1];
	SQL_QuoteString(g_hDb, steamid, szsteamid, 32*2+1);      	
	Format(szQuery, 255, sql_resetCheat1, szsteamid);       
	SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery,DBPrio_Low);
	Format(szQuery, 255, sql_resetCheat2, szsteamid);       
	SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery,DBPrio_Low);	   
	Format(szQuery, 255, sql_resetCheat3, szsteamid);       
	SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery,DBPrio_Low);	   	
}

public db_viewPlayerRank2(client, String:szSteamId[32])
{
	decl String:szQuery[512];  
	Format(g_pr_szrank[client], 512, "");	
	Format(szQuery, 512, sql_selectRankedPlayer, szSteamId);  
	SQL_TQuery(g_hDb, SQL_ViewRankedPlayer2Callback, szQuery, client);
}

public SQL_ViewRankedPlayer2Callback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	new client = data;
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{	
		if (!IsClientConnected(client))
			return;	
		decl String:szSteamId[32];
		GetClientAuthString(client, szSteamId, 32);	
		
		decl String:szQuery[512];
		decl String:szName[MAX_NAME_LENGTH];
		decl String:szSteamIdTarget[32];	
		SQL_FetchString(hndl, 0, szSteamIdTarget, 32);
		SQL_FetchString(hndl, 1, szName, MAX_NAME_LENGTH);
				
		new Handle:pack = CreateDataPack();
		WritePackCell(pack, client);
		WritePackString(pack, szName);
		Format(szQuery, 512, sql_selectChallengesCompare, szSteamId,szSteamIdTarget,szSteamIdTarget,szSteamId);
		SQL_TQuery(g_hDb, sql_selectChallengesCompareCallback, szQuery, pack);
	}
}

public sql_selectChallengesCompareCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	new winratio=0;
	new challenges= SQL_GetRowCount(hndl);
	new pointratio=0;
	decl String:szWinRatio[32];
	decl String:szPointsRatio[32];
	decl String:szName[MAX_NAME_LENGTH]	
	new Handle:pack = data;
	ResetPack(pack);
	new client = ReadPackCell(pack);      
	if (!IsClientConnected(client))
		return;
	decl String:szSteamId[32];
	GetClientAuthString(client, szSteamId, 32);	
	ReadPackString(pack, szName, MAX_NAME_LENGTH);
	CloseHandle(pack);	
	if(SQL_HasResultSet(hndl))
	{
		while (SQL_FetchRow(hndl))
		{
			decl String:szID[32];
			new bet;
			SQL_FetchString(hndl, 0, szID, 32);
			bet = SQL_FetchInt(hndl,2);
			if (StrEqual(szID, szSteamId))
			{
				winratio++;
				pointratio+= bet;
			}
			else
			{
				winratio--;
				pointratio-= bet;	
			}
		}
		if (winratio>0)
			Format(szWinRatio, 32, "+%i",winratio);
		else
			Format(szWinRatio, 32, "%i",winratio);
			
		if (pointratio>0)
			Format(szPointsRatio, 32, "+%ip",pointratio);
		else
			Format(szPointsRatio, 32, "%ip",pointratio);			
		
		if (winratio>0)
		{
			if (pointratio>0)
				PrintToChat(client,"[%cKZ%c] %cYou have played %c%i%c challenges against %c%s%c (win/loss ratio: %c%s%c, points ratio: %c%s%c)", MOSSGREEN,WHITE,GRAY,PURPLE,challenges,GRAY,PURPLE, szName,GRAY, GREEN,szWinRatio,GRAY,GREEN,szPointsRatio,GRAY);
			else
					if (pointratio<0)
						PrintToChat(client,"[%cKZ%c] %cYou have played %c%i%c challenges against %c%s%c (win/loss ratio: %c%s%c, points ratio: %c%s%c)", MOSSGREEN,WHITE,GRAY,PURPLE,challenges,GRAY,PURPLE, szName,GRAY, GREEN,szWinRatio,GRAY,RED,szPointsRatio,GRAY);
					else
						PrintToChat(client,"[%cKZ%c] %cYou have played %c%i%c challenges against %c%s%c (win/loss ratio: %c%s%c, points ratio: %c%s%c)", MOSSGREEN,WHITE,GRAY,PURPLE,challenges,GRAY,PURPLE, szName,GRAY, GREEN,szWinRatio,GRAY,YELLOW,szPointsRatio,GRAY);	
		}
		else
		{
			if (winratio<0)
			{
				if (pointratio>0)
					PrintToChat(client,"[%cKZ%c] %cYou have played %c%i%c challenges against %c%s%c (win/loss ratio: %c%s%c, points ratio: %c%s%c)", MOSSGREEN,WHITE,GRAY,PURPLE,challenges,GRAY,PURPLE, szName,GRAY, RED,szWinRatio,GRAY,GREEN,szPointsRatio,GRAY);
				else
					if (pointratio<0)
						PrintToChat(client,"[%cKZ%c] %cYou have played %c%i%c challenges against %c%s%c (win/loss ratio: %c%s%c, points ratio: %c%s%c)", MOSSGREEN,WHITE,GRAY,PURPLE,challenges,GRAY,PURPLE, szName,GRAY, RED,szWinRatio,GRAY,RED,szPointsRatio,GRAY);
					else
						PrintToChat(client,"[%cKZ%c] %cYou have played %c%i%c challenges against %c%s%c (win/loss ratio: %c%s%c, points ratio: %c%s%c)", MOSSGREEN,WHITE,GRAY,PURPLE,challenges,GRAY,PURPLE, szName,GRAY, RED,szWinRatio,GRAY,YELLOW,szPointsRatio,GRAY);	
		
			}
			else
			{
				if (pointratio>0)
					PrintToChat(client,"[%cKZ%c] %cYou have played %c%i%c challenges against %c%s%c (win/loss ratio: %c%s%c, points ratio: %c%s%c)", MOSSGREEN,WHITE,GRAY,PURPLE,challenges,GRAY,PURPLE, szName,GRAY, YELLOW,szWinRatio,GRAY,GREEN,szPointsRatio,GRAY);
				else
					if (pointratio<0)
						PrintToChat(client,"[%cKZ%c] %cYou have played %c%i%c challenges against %c%s%c (win/loss ratio: %c%s%c, points ratio: %c%s%c)", MOSSGREEN,WHITE,GRAY,PURPLE,challenges,GRAY,PURPLE, szName,GRAY, YELLOW,szWinRatio,GRAY,RED,szPointsRatio,GRAY);
					else
						PrintToChat(client,"[%cKZ%c] %cYou have played %c%i%c challenges against %c%s%c (win/loss ratio: %c%s%c, points ratio: %c%s%c)", MOSSGREEN,WHITE,GRAY,PURPLE,challenges,GRAY,PURPLE, szName,GRAY, YELLOW,szWinRatio,GRAY,YELLOW,szPointsRatio,GRAY);	
			}
		}	
	}
	else
		PrintToChat(client,"[%cKZ%c] No challenges againgst %s found", szName);
}

//COMPARE
public db_viewPlayerAll2(client, String:szPlayerName[MAX_NAME_LENGTH])
{
	decl String:szQuery[512];
	decl String:szName[MAX_NAME_LENGTH*2+1];
	SQL_QuoteString(g_hDb, szPlayerName, szName, MAX_NAME_LENGTH*2+1);      
	Format(szQuery, 512, sql_selectPlayerRankAll, szName);
	new Handle:pack = CreateDataPack();
	WritePackCell(pack, client);
	WritePackString(pack, szPlayerName);
	SQL_TQuery(g_hDb, SQL_ViewPlayerAll2Callback, szQuery, pack);
}
//COMPARE
public SQL_ViewPlayerAll2Callback(Handle:owner, Handle:hndl, const String:error[], any:data)
{  
	decl String:szName[MAX_NAME_LENGTH]; 
	new Handle:pack = data;	
	ResetPack(pack);
	new client = ReadPackCell(pack);      
	ReadPackString(pack, szName, MAX_NAME_LENGTH)
	decl String:szSteamId[32];
	decl String:szSteamId2[32];
	if (!IsClientConnected(client))	
	{
		CloseHandle(pack);
		return;
	}
	GetClientAuthString(client, szSteamId, 32);
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{   	
		SQL_FetchString(hndl, 1, szSteamId2, 32);	
		if (!StrEqual(szSteamId2,szSteamId))
			db_viewPlayerRank2(client,szSteamId2);
	}
	else
		PrintToChat(client, "%t", "PlayerNotFound", MOSSGREEN,WHITE, szName);
	CloseHandle(pack);
}

public dbCheckFileSize()
{
	decl String:szQuery[256];
	Format(szQuery, 256, sqlglobal_selectFilesize, g_szMapName);
	SQL_TQuery(g_hDbGlobal, sqlglobal_selectFilesizeCallback, szQuery);
}

public sqlglobal_selectFilesizeCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{   
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{		
		new filesize = SQL_FetchInt(hndl, 0);
		if (filesize == g_unique_FileSize)
		{
			g_bglobalValidFilesize=true;
			db_GetMapRecord_Global();
		}
		else
			g_bglobalValidFilesize=false;
	}
	else
		dbInsertGlobalMap();
}

public dbInsertGlobalMap()
{
	decl String:szQuery[256];
	Format(szQuery, 256, sqlglobal_insertFilesize, g_szMapName,g_unique_FileSize);
	SQL_TQuery(g_hDbGlobal, sqlglobal_insertFilesizeCallback, szQuery);
}

public db_InsertBan(String:szSteamId[32], String:szName[64])
{
	decl String:szQuery[256];
	Format(szQuery, 256, sqlglobal_insertBan, szSteamId,szName);
	SQL_TQuery(g_hDbGlobal, SQL_CheckCallback, szQuery,DBPrio_Low);
}

public sqlglobal_insertFilesizeCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	g_bglobalValidFilesize=true;
	db_GetMapRecord_Global();
}

public db_deleteInvalidGlobalEntries()
{
	decl String:szQuery[255];      
	if (g_btickrate64)
		Format(szQuery, 255, sqlglobal_selectPlayers, g_szMapName); 
	else
		Format(szQuery, 255, sqlglobal_selectPlayers128, g_szMapName); 
	SQL_TQuery(g_hDbGlobal, sqlglobal_selectPlayers2Callback, szQuery);	
}

public sqlglobal_selectPlayers2Callback(Handle:owner, Handle:hndl, const String:error[], any:data)
{   
	decl String:szQuery[255];
	decl String:szMapname[64];
	decl String:szSteamid[32];   
	new i=1;
	if(SQL_HasResultSet(hndl))
	{		
		while (SQL_FetchRow(hndl))
		{
			if (i>5)
			{
				SQL_FetchString(hndl, 1, szSteamid, 32);
				SQL_FetchString(hndl, 2, szMapname, 64);
				if (g_btickrate64)
					Format(szQuery, 255, sqlglobal_deletePlayer, szSteamid,szMapname);      
				else
					Format(szQuery, 255, sqlglobal_deletePlayer128, szSteamid,szMapname); 
				SQL_TQuery(g_hDbGlobal, SQL_CheckCallback, szQuery);	
			}
			i++;
		}
	}
}
			
public db_GetMapRecord_Global()
{
	decl String:szQuery[255];    
	if (g_btickrate64)
	{
		Format(szQuery, 255, sqlglobal_selectGlobalRecord, g_szMapName);  
		SQL_TQuery(g_hDbGlobal, sql_selectMapRecordGlobalCallback, szQuery);
	}
	else
	{
		Format(szQuery, 255, sqlglobal_selectGlobalRecord128, g_szMapName);
		SQL_TQuery(g_hDbGlobal, sql_selectMapRecordGlobal128Callback, szQuery);	
	}
}
public sql_selectMapRecordGlobalCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		if (SQL_FetchFloat(hndl, 0) > -1.0)
		{
			SQL_FetchString(hndl, 0, g_szRecordGlobalPlayer, MAX_NAME_LENGTH);
			g_fRecordTimeGlobal = SQL_FetchFloat(hndl, 1);		
		}
		else
			g_fRecordTimeGlobal = 9999999.0;	
	}
	else
		g_fRecordTimeGlobal = 9999999.0;		   
}

public sql_selectMapRecordGlobal128Callback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		if (SQL_FetchFloat(hndl, 0) > -1.0)
		{
			SQL_FetchString(hndl, 0, g_szRecordGlobalPlayer128, MAX_NAME_LENGTH);
			g_fRecordTimeGlobal128 = SQL_FetchFloat(hndl, 1);		
		}
		else
			g_fRecordTimeGlobal128 = 9999999.0;	
	}
	else
		g_fRecordTimeGlobal128 = 9999999.0;		   
}

public db_selectGlobalTopClimbers(client)
{
	if (!g_BGlobalDBConnected) return;
	decl String:szQuery[1024];       
	Format(szQuery, 1024, sqlglobal_selectGlobalTop, g_szMapName);   
	if (g_hDbGlobal != INVALID_HANDLE)
	SQL_TQuery(g_hDbGlobal, sql_selectGlobalTopClimbers, szQuery, client);
}

public sql_selectGlobalTopClimbers(Handle:owner, Handle:hndl, const String:error[], any:data)
{   
	new client = data;    
	if(SQL_HasResultSet(hndl))
	{		
		decl String:szValue[64];
		decl String:szName[MAX_NAME_LENGTH];
		decl String:szTeleports[32];
		new Float:time;
		new teleports;
		new Handle:menu = CreateMenu(GlobalMapMenuHandler);	
		SetMenuPagination(menu, 5);
		SetMenuTitle(menu, "Top 5 Global Climbers (tickrate 64)\n       Time            TP's        Player");    
		new i=1;
		while (SQL_FetchRow(hndl))
		{
			SQL_FetchString(hndl, 0, szName, MAX_NAME_LENGTH);
			time = SQL_FetchFloat(hndl, 1); 
			teleports = SQL_FetchInt(hndl, 2);	
			if (teleports < 10)
				Format(szTeleports, 32, "    %i",teleports);
				else
			if (teleports < 100)
				Format(szTeleports, 32, "  %i",teleports);
			else
				Format(szTeleports, 32, "%i",teleports);
		
			FormatTimeFloat(client, time, 3);		
			if (time<3600.0)
				Format(g_szTime[client], 32, "   %s", g_szTime[client]);				
			Format(szValue, 64, "%s  |  %s    » %s", g_szTime[client], szTeleports, szName);
					
			AddMenuItem(menu, szValue, szValue, ITEMDRAW_DEFAULT);
			i++;
		}
		SetMenuOptionFlags(menu, MENUFLAG_BUTTON_EXIT);
		DisplayMenu(menu, client, MENU_TIME_FOREVER);
		if (i == 1 && IsClientInGame(client))
			PrintToChat(client, "%t", "NoGlobalRecords64", MOSSGREEN,WHITE, g_szMapName);
	}
		
}

public db_selectGlobalTopClimbers128(client)
{
	if (!g_BGlobalDBConnected) return;
	decl String:szQuery[1024];       
	Format(szQuery, 1024, sqlglobal_selectGlobalTop128, g_szMapName);   
	if (g_hDbGlobal != INVALID_HANDLE)
		SQL_TQuery(g_hDbGlobal, sql_selectGlobalTopClimbers128, szQuery, client);
}

public sql_selectGlobalTopClimbers128(Handle:owner, Handle:hndl, const String:error[], any:data)
{   
	new client = data;    
	if(SQL_HasResultSet(hndl))
	{		
		decl String:szValue[64];
		decl String:szName[MAX_NAME_LENGTH];
		decl String:szTeleports[32];
		new Float:time;
		new teleports;
		new Handle:menu = CreateMenu(GlobalMapMenuHandler);	
		SetMenuPagination(menu, 5);
		SetMenuTitle(menu, "Top 5 Global Climbers (tickrate 128)\n       Time            TP's        Player");    
		new i=1;
		while (SQL_FetchRow(hndl))
		{
			SQL_FetchString(hndl, 0, szName, MAX_NAME_LENGTH);
			time = SQL_FetchFloat(hndl, 1); 
			teleports = SQL_FetchInt(hndl, 2);	
			if (teleports < 10)
				Format(szTeleports, 32, "    %i",teleports);
				else
			if (teleports < 100)
				Format(szTeleports, 32, "  %i",teleports);
			else
				Format(szTeleports, 32, "%i",teleports);
		
			FormatTimeFloat(client, time, 3);		
			if (time<3600.0)
				Format(g_szTime[client], 32, "   %s", g_szTime[client]);				
			Format(szValue, 64, "%s  |  %s    » %s", g_szTime[client], szTeleports, szName);
					
			AddMenuItem(menu, szValue, szValue, ITEMDRAW_DEFAULT);
			i++;
		}
		SetMenuOptionFlags(menu, MENUFLAG_BUTTON_EXIT);
		DisplayMenu(menu, client, MENU_TIME_FOREVER);
		if (i == 1 && IsClientInGame(client))
			PrintToChat(client, "%t", "NoGlobalRecords128", MOSSGREEN,WHITE, g_szMapName);
	}
		
}

public db_insertGlobalRecord(client)
{
	decl String:szQuery[255];
	decl String:szSteamId[32];
	decl String:szUName[MAX_NAME_LENGTH];
	if (IsClientInGame(client))
	{
		GetClientAuthString(client, szSteamId, 32);
		GetClientName(client, szUName, MAX_NAME_LENGTH);
	}
	else
		return;	
	decl String:szName[MAX_NAME_LENGTH*2+1];      
	SQL_QuoteString(g_hDb, szUName, szName, MAX_NAME_LENGTH*2+1);
	
	if (g_OverallTp[client]<0)
		g_OverallTp[client]=0;
	if (g_btickrate64)
		Format(szQuery, 255, sqlglobal_insertPlayer, szSteamId, g_szMapName, szName,g_fFinalTime[client],g_OverallTp[client]);
	else
		Format(szQuery, 255, sqlglobal_insertPlayer128, szSteamId, g_szMapName, szName,g_fFinalTime[client],g_OverallTp[client]);
	SQL_TQuery(g_hDbGlobal, SQL_CheckCallback, szQuery,DBPrio_Low);
}

public db_updateGlobalRecord(client)
{
	decl String:szQuery[255];
	decl String:szSteamId[32];
	decl String:szUName[MAX_NAME_LENGTH];
	if (IsClientInGame(client))
	{
		GetClientAuthString(client, szSteamId, 32);
		GetClientName(client, szUName, MAX_NAME_LENGTH);
	}
	else
		return;
	decl String:szName[MAX_NAME_LENGTH*2+1];      
	SQL_QuoteString(g_hDb, szUName, szName, MAX_NAME_LENGTH*2+1);
	if (g_OverallTp[client]<0)
		g_OverallTp[client]=0;
		
	if (g_btickrate64)
		Format(szQuery, 255, sqlglobal_updatePlayer, szName,g_fFinalTime[client],g_OverallTp[client], szSteamId, g_szMapName); 
	else
		Format(szQuery, 255, sqlglobal_updatePlayer128, szName,g_fFinalTime[client],g_OverallTp[client], szSteamId, g_szMapName); 
	SQL_TQuery(g_hDbGlobal, SQL_CheckCallback, szQuery,DBPrio_Low);
}

public db_GlobalRecord(client)
{
	decl String:szQuery[255];
	if (g_btickrate64)
		Format(szQuery, 255, sqlglobal_selectTop5Players, g_szMapName);
	else
		Format(szQuery, 255, sqlglobal_selectTop5Players128, g_szMapName);
	SQL_TQuery(g_hDbGlobal, SQL_SelectGlobalPlayersCallback, szQuery, client);		
}
public SQL_SelectGlobalPlayersCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{       
	new client = data;
	new Float: time;
	decl String:szSteamId[32];
	decl String:szSteamId2[32];
	new counter=0;
	new bool: newtime=false;
	new bool: newpersonalbest=false;
	if (IsClientConnected(client))
	{
		GetClientAuthString(client, szSteamId, 32);
		if(SQL_HasResultSet(hndl))
		{
			while (SQL_FetchRow(hndl))
			{		
				time = SQL_FetchFloat(hndl, 0);
				SQL_FetchString(hndl, 1, szSteamId2, 32);
				if (g_fFinalTime[client] < time && (!StrEqual(szSteamId,szSteamId2)))
					newtime=true;
				if (StrEqual(szSteamId,szSteamId2) && g_fFinalTime[client] < time)
					newpersonalbest=true;
				counter++;
			}
			if (newpersonalbest)
				db_updateGlobalRecord(client);
			else
				if (newtime || counter<5)
				db_insertGlobalRecord(client);			
		}
	}
}

///////////////////

public db_setupDatabase()
{
	decl String:szError[255];
	g_hDb = SQL_Connect("kztimer", false, szError, 255);
        
	if(g_hDb == INVALID_HANDLE)
	{
		LogError("[KZ] Unable to connect to database (%s)", szError);
		return;
	}
        
	decl String:szIdent[8];
	SQL_ReadDriver(g_hDb, szIdent, 8);
        
	if(strcmp(szIdent, "mysql", false) == 0)
	{
		g_DbType = MYSQL;
	}
	else 
		if(strcmp(szIdent, "sqlite", false) == 0)
			g_DbType = SQLITE;
		else
		{
			LogError("[KZ] Invalid Database-Type");
			return;
		}
		
	SQL_FastQuery(g_hDb,"SET NAMES  'utf8'");
	db_createTables();
	
	//PRIVATE globalconnection.sp
	if (g_bGlobalDB)
		ConnectToGlobalDB();
}



public db_createTables()
{
	SQL_LockDatabase(g_hDb);        
	SQL_FastQuery(g_hDb, sql_createPlayertmp);
	SQL_FastQuery(g_hDb, sql_createPlayertimes);
	SQL_FastQuery(g_hDb, sql_createPlayerjumpstats);
	SQL_FastQuery(g_hDb, sql_createPlayerRank);
	SQL_FastQuery(g_hDb, sql_createChallenges);
	SQL_FastQuery(g_hDb, sql_createMapButtons);
	SQL_FastQuery(g_hDb, sql_createPlayerOptions);
	SQL_UnlockDatabase(g_hDb);
}

public db_insertPlayerChallenge(client)
{
	if (!IsClientConnected(client))
		return;
	decl String:szQuery[255];
	decl String:szSteamId[32];
	new points;
	new cps;
	GetClientAuthString(client, szSteamId, 32);
	points = g_CBet[client] * g_pr_points_finished;
	if (g_bCCheckpoints[client])
		cps=1;
	else
		cps=0;
	Format(szQuery, 255, sql_insertChallenges, szSteamId, g_szCOpponentID[client],points,g_szMapName, cps);
	SQL_TQuery(g_hDb, sql_insertChallengesCallback, szQuery,client,DBPrio_Low);
}

public sql_insertChallengesCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
}	
public db_insertPlayer(client)
{
	decl String:szQuery[255];
	decl String:szSteamId[32];
	decl String:szUName[MAX_NAME_LENGTH];
	if (IsClientConnected(client))
	{
		GetClientAuthString(client, szSteamId, 32);
		GetClientName(client, szUName, MAX_NAME_LENGTH);
	}
	else
		return;	
	decl String:szName[MAX_NAME_LENGTH*2+1];      
	SQL_QuoteString(g_hDb, szUName, szName, MAX_NAME_LENGTH*2+1);
	Format(szQuery, 255, sql_insertPlayer, szSteamId, g_szMapName, szName); 
	SQL_TQuery(g_hDb, SQL_InsertPlayerCallback, szQuery,client,DBPrio_Low);
}

public SQL_InsertPlayerCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
}	
	
public db_insertPlayerTmp2(client, String:szSteamId[32], String:szMapName[MAX_MAP_LENGTH], Float:xx)
{
	decl String:szQuery[512];
	if (xx==0.0)
	{
		Format(szQuery, 512, sql_insertPlayerTmp, szSteamId, g_szMapName); 
		if (!IsFakeClient(client))
			SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery, client,DBPrio_Low);
	}
}

deleteDeadDBTmps()
{
	decl String:szQuery[512];
	Format(szQuery, 512, sql_deleteDeadPlayer); 
	SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery);
	Format(szQuery, 512, sql_deleteDeadPlayerTmp); 
	SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery);
}

public db_deleteTmp(client, String:szSteamId[32], String:szMapName[MAX_MAP_LENGTH])
{
	decl String:szQuery[256];
	Format(szQuery, 256, sql_deletePlayerTmp, szSteamId, g_szMapName); 
	SQL_TQuery(g_hDb, sql_deletePlayerCheckCallback, szQuery, client,DBPrio_Low);
}
public db_deleteMapButtons(String:szMapName[MAX_MAP_LENGTH])
{
	decl String:szQuery[256];
	Format(szQuery, 256, sql_deleteMapButtons, g_szMapName); 
	SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery);
}

public db_setTmpDataRecord(client, String:szSteamId[32], String:szMapName[MAX_MAP_LENGTH])
{
	decl String:szQuery[256];
	Format(szQuery, 256, sql_selectPlayerTmp, szSteamId); 
	SQL_TQuery(g_hDb, SQL_selectPlayerTmpCallback, szQuery, client);
}
public SQL_selectPlayerTmpCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	new client = data;
	decl String:szSteamId[32];
	decl String:szQuery2[255];
	decl String:szMapName[MAX_MAP_LENGTH];
	if (IsClientConnected(client))
	{
		GetClientAuthString(client, szSteamId, 32);
		if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
		{
			SQL_FetchString(hndl, 0, szMapName, MAX_MAP_LENGTH);
			if (StrEqual(szMapName, g_szMapName))
				return;
			Format(szQuery2, 255, sql_updatePlayerTmp, g_szMapName, szSteamId); 		
			SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery2, client,DBPrio_Low);
			return;
		}
		db_insertPlayerTmp2(client, szSteamId, g_szMapName, 0.0);
	}
}	

public db_selectLastRun(client)
{
	decl String:szQuery[512];
	decl String:szSteamId[32];

	if (IsClientConnected(client))
		GetClientAuthString(client, szSteamId, 32);
	else
		return;
	Format(szQuery, 512, sql_selectLastRun, szSteamId, g_szMapName);     
	SQL_TQuery(g_hDb, SQL_LastRunCallback, szQuery, client);
}

public SQL_LastRunCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	new client = data;	
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl) && IsClientInGame(client))
	{
	
		//Get last psition
		g_fPlayerCordsRestore[client][0] = SQL_FetchFloat(hndl, 0);
		g_fPlayerCordsRestore[client][1] = SQL_FetchFloat(hndl, 1);
		g_fPlayerCordsRestore[client][2] = SQL_FetchFloat(hndl, 2);
		g_fPlayerAnglesRestore[client][0] = SQL_FetchFloat(hndl, 3);
		g_fPlayerAnglesRestore[client][1] = SQL_FetchFloat(hndl, 4);
		g_fPlayerAnglesRestore[client][2] = SQL_FetchFloat(hndl, 5);		
		g_OverallTp[client] = SQL_FetchInt(hndl, 6);
		g_OverallCp[client] = SQL_FetchInt(hndl, 7);
		if (g_OverallTp[client] < 0) 
			g_OverallTp[client] = 0;
		if (g_OverallCp[client] < 0) 
			g_OverallCp[client] = 0;

		//Set new start time	
		g_fStartTime[client] = SQL_FetchFloat(hndl, 8);
		g_fStartTime[client] = GetEngineTime() - g_fStartTime[client];   
		
		   	
		if (SQL_FetchFloat(hndl, 0) == -1.0 && SQL_FetchFloat(hndl, 1) == -1.0 && SQL_FetchFloat(hndl, 2) == -1.0) 
		{
			g_bRestoreC[client] = false;
			g_bRestoreCMsg[client] = false;
		}
		else
		{
			g_bRestoreC[client] = true;
			g_bRestoreCMsg[client]=true;
		}
			
		//Timer Display
		g_bPlayerJumped[client] = false;
		g_bTimeractivated[client] = true;
	}
	else
	{
		g_bTimeractivated[client] = false;
	}

}

public db_viewPersonalRecords(client, String:szSteamId[32], String:szMapName[MAX_MAP_LENGTH])
{
	decl String:szQuery[512];
	Format(szQuery, 512, sql_selectPersonalRecords, szSteamId, szMapName);
	SQL_TQuery(g_hDb, SQL_selectPersonalRecordsCallback, szQuery, client,DBPrio_Low);
}

public SQL_selectPersonalRecordsCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	new client = data;
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		g_fPersonalRecord[client] = SQL_FetchFloat(hndl, 3);
		g_fPersonalRecordPro[client] = SQL_FetchFloat(hndl, 4); 
		
		if (g_fPersonalRecordPro[client]>0.0)
			db_viewMapRankPro(client);
		else
			g_fPersonalRecordPro[client] = 0.0;
		if (g_fPersonalRecord[client]>0.0)
			db_viewMapRankTp(client);
		else
			g_fPersonalRecord[client] = 0.0;
	}
	else
	{
		g_fPersonalRecord[client] = 0.0;
		g_fPersonalRecordPro[client] = 0.0;
	}
}                

public db_viewJumpStats(client, String:szSteamId[32])
{
	decl String:szQuery[1024];       
	Format(szQuery, 1024, sql_selectJumpStats, szSteamId);  
	SQL_TQuery(g_hDb, SQL_ViewJumpStatsCallback, szQuery, client,DBPrio_Low);
}

public SQL_ViewJumpStatsCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	new client = data;
	g_bClimbersMenuOpen[client] = false;
	g_bMenuOpen[client] = true;		
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		decl String:szSteamId[32];				
		decl String:szName[32];	
		decl String:szVr[255];	
		
		//get the result
		SQL_FetchString(hndl, 0, szSteamId, MAX_NAME_LENGTH);
		SQL_FetchString(hndl, 1, szName, MAX_NAME_LENGTH);
		new Float:bhoprecord = SQL_FetchFloat(hndl, 2);
		new Float:bhoppre = SQL_FetchFloat(hndl, 3);
		new Float:bhopmax = SQL_FetchFloat(hndl, 4);
		new bhopstrafes = SQL_FetchInt(hndl, 5);
		new bhopsync = SQL_FetchInt(hndl, 6);
		new Float:ljrecord = SQL_FetchFloat(hndl, 7);
		new Float:ljpre = SQL_FetchFloat(hndl, 8);
		new Float:ljmax = SQL_FetchFloat(hndl, 9);
		new ljstrafes = SQL_FetchInt(hndl, 10);
		new ljsync = SQL_FetchInt(hndl, 11);		
		new Float:multibhoprecord = SQL_FetchFloat(hndl, 12);
		new Float:multibhoppre = SQL_FetchFloat(hndl, 13);
		new Float:multibhopmax = SQL_FetchFloat(hndl, 14);
		new multibhopstrafes = SQL_FetchInt(hndl, 15);
		new multibhopsync = SQL_FetchInt(hndl, 17);
		new Float:wjrecord = SQL_FetchFloat(hndl, 18);
		new Float:wjpre = SQL_FetchFloat(hndl, 19);
		new Float:wjmax = SQL_FetchFloat(hndl, 20);
		new wjstrafes = SQL_FetchInt(hndl, 21);	 
		new wjsync = SQL_FetchInt(hndl, 22);	
		new Float:dropbhoprecord = SQL_FetchFloat(hndl, 23);
		new Float:dropbhoppre = SQL_FetchFloat(hndl, 24);
		new Float:dropbhopmax = SQL_FetchFloat(hndl, 25);
		new dropbhopstrafes = SQL_FetchInt(hndl, 26);	
		new dropbhopsync = SQL_FetchInt(hndl, 27);	
		new Float:ljheight = SQL_FetchFloat(hndl, 28);
		new Float:bhopheight = SQL_FetchFloat(hndl, 29);
		new Float:multibhopheight = SQL_FetchFloat(hndl, 30);
		new Float:dropbhopheight = SQL_FetchFloat(hndl, 31);
		new Float:wjheight = SQL_FetchFloat(hndl, 32);
		
		new bool:ljtrue;
		
		
		if (bhoprecord >0.0 || ljrecord > 0.0 || multibhoprecord > 0.0 || wjrecord > 0.0 || dropbhoprecord > 0.0)
		{										 
			Format(szVr, 255, "Jumpstats of %s\nType               Distance    Strafes   Pre            Max        Height   Sync", szName);
			new Handle:menu = CreateMenu(JumpStatsMenuHandler);
			SetMenuTitle(menu, szVr);
			if (ljrecord > 0)
			{
				if (ljstrafes>9)
					Format(szVr, 255, "LJ:              %.3f       %i       %.2f*    %.2f   %.1f      %i%c", ljrecord,ljstrafes,ljpre,ljmax,ljheight,ljsync,PERCENT);
				else
					Format(szVr, 255, "LJ:              %.3f         %i       %.2f*    %.2f   %.1f      %i%c", ljrecord,ljstrafes,ljpre,ljmax,ljheight,ljsync,PERCENT);
				AddMenuItem(menu, szVr, szVr);	
				ljtrue=true;
			}
			if (wjrecord > 0.0)
			{
				if (wjstrafes>9)
					Format(szVr, 255, "WJ:            %.3f       %i       %.2f*    %.2f   %.1f      %i%c", wjrecord,wjstrafes,wjpre,wjmax,wjheight,wjsync,PERCENT);
				else
					Format(szVr, 255, "WJ:            %.3f         %i       %.2f*    %.2f   %.1f      %i%c", wjrecord,wjstrafes,wjpre,wjmax,wjheight,wjsync,PERCENT);	
				AddMenuItem(menu, szVr, szVr);	
			}	
			if (bhoprecord > 0.0)
			{
				if (bhopstrafes>9)
					Format(szVr, 255, "Bhop:         %.3f       %i       %.2f*    %.2f   %.1f      %i%c", bhoprecord,bhopstrafes,bhoppre,bhopmax,bhopheight,bhopsync,PERCENT);
				else
					Format(szVr, 255, "Bhop:         %.3f         %i       %.2f*    %.2f   %.1f      %i%c", bhoprecord,bhopstrafes,bhoppre,bhopmax,bhopheight,bhopsync,PERCENT);
				AddMenuItem(menu, szVr, szVr);	
			}
			if (multibhoprecord > 0.0)
			{
				if (multibhopstrafes>9)
					Format(szVr, 255, "MultiBhop: %.3f       %i       %.2f*    %.2f   %.1f      %i%c", multibhoprecord,multibhopstrafes,multibhoppre,multibhopmax,multibhopheight,multibhopsync,PERCENT);
				else
					Format(szVr, 255, "MultiBhop: %.3f         %i       %.2f*    %.2f   %.1f      %i%c", multibhoprecord,multibhopstrafes,multibhoppre,multibhopmax,multibhopheight,multibhopsync,PERCENT);
				AddMenuItem(menu, szVr, szVr);	
			}
			if (dropbhoprecord > 0.0)
			{
				if (dropbhopstrafes>9)
					Format(szVr, 255, "DropBhop: %.3f       %i       %.2f*    %.2f   %.1f      %i%c", dropbhoprecord,dropbhopstrafes,dropbhoppre,dropbhopmax,dropbhopheight,dropbhopsync,PERCENT);
				else
					Format(szVr, 255, "DropBhop: %.3f         %i       %.2f*    %.2f   %.1f      %i%c", dropbhoprecord,dropbhopstrafes,dropbhoppre,dropbhopmax,dropbhopheight,dropbhopsync,PERCENT);	
				AddMenuItem(menu, szVr, szVr);	
			}		
			if (ljtrue && !g_bPreStrafe)
			{

				Format(szVr, 255, "* = TakeOff", szName);
				AddMenuItem(menu, szVr, szVr);	
			}
				
			SetMenuOptionFlags(menu, MENUFLAG_BUTTON_EXIT);
			DisplayMenu(menu, client, MENU_TIME_FOREVER);	
		}
		else
			PrintToChat(client, "%t", "noJumpRecords",MOSSGREEN,WHITE);

		
	}
	else
	{
		ProfileMenu(client, -1);
		PrintToChat(client, "%t", "noJumpRecords",MOSSGREEN,WHITE);
	}
}

public JumpStatsMenuHandler(Handle:menu, MenuAction:action, param1,param2)
{
	if (action ==  MenuAction_Cancel || action ==  MenuAction_Select)
	{
		ProfileMenu(param1, -1);
	}
	else if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}

public db_viewPersonalLJRecord(client, String:szSteamId[32])
{
	decl String:szQuery[512];      
	Format(szQuery, 512, sql_selectPlayerJumpLJ, szSteamId);  
	SQL_TQuery(g_hDb, SQL_LJRecordCallback, szQuery, client,DBPrio_Low);
}

public db_viewPersonalBhopRecord(client, String:szSteamId[32])
{
	decl String:szQuery[512];       
	Format(szQuery, 512, sql_selectPlayerJumpBhop, szSteamId);  
	SQL_TQuery(g_hDb, SQL_ViewBhopRecordCallback, szQuery, client,DBPrio_Low);
}

public db_viewPersonalDropBhopRecord(client, String:szSteamId[32])
{
	decl String:szQuery[512];       
	Format(szQuery, 512, sql_selectPlayerJumpDropBhop, szSteamId);  
	SQL_TQuery(g_hDb, SQL_ViewDropBhopRecordCallback, szQuery, client,DBPrio_Low);
}


public db_viewPersonalWeirdRecord(client, String:szSteamId[32])
{
	decl String:szQuery[512];       
	Format(szQuery, 512, sql_selectPlayerJumpWJ, szSteamId);  
	SQL_TQuery(g_hDb, SQL_ViewWeirdRecordCallback, szQuery, client,DBPrio_Low);
}


public db_viewPersonalMultiBhopRecord(client, String:szSteamId[32])
{
	decl String:szQuery[512];       
	Format(szQuery, 512, sql_selectPlayerJumpMultiBhop, szSteamId);  
	SQL_TQuery(g_hDb, SQL_ViewMultiBhopRecordCallback, szQuery, client,DBPrio_Low);
}

public GetDBName(client, String:szSteamId[32])
{
	decl String:szQuery[512];      
	Format(szQuery, 512, sql_selectRankedPlayer, szSteamId); 
	SQL_TQuery(g_hDb, GetDBNameCallback, szQuery, client,DBPrio_Low);
}

public GetDBNameCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{               
	new client = data;
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		SQL_FetchString(hndl, 1, g_szProfileName[client], MAX_NAME_LENGTH);	
		db_viewPlayerAll(client, g_szProfileName[client]);
	}
}

public SQL_LJRecordCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{               
	new client = data;
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		g_fPersonalLjRecord[client] = SQL_FetchFloat(hndl, 2);
		if (g_fPersonalLjRecord[client] > -1.0)
		{
			decl String:szSteamId[32];
			decl String:szQuery[512];   
			if (client > MAXPLAYERS)
			{
				Format(szSteamId, 32, "%s", g_pr_szSteamID[client]); 
				Format(szQuery, 255, sql_selectPlayerRankLj, szSteamId);
				SQL_TQuery(g_hDb, SQL_viewLjRecordCallback2, szQuery, client,DBPrio_Low);
			}
			else
			{
				if (IsClientConnected(client))
				{
					GetClientAuthString(client, szSteamId, 32);
					Format(szQuery, 255, sql_selectPlayerRankLj, szSteamId);
					SQL_TQuery(g_hDb, SQL_viewLjRecordCallback2, szQuery, client,DBPrio_Low);
				}
			}

		}
		else
		{
			g_LjRank[client] = 99999999;
			g_fPersonalLjRecord[client] = -1.0;
			ContinueRecalc(client);
		}
	}
	else
	{
		g_LjRank[client] = 99999999;
		g_fPersonalLjRecord[client] = -1.0;
		ContinueRecalc(client);
	}
}

public SQL_viewLjRecordCallback2(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	new client = data;
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{		
		g_LjRank[client]= SQL_GetRowCount(hndl);
	}
	ContinueRecalc(client);
}

public ContinueRecalc(client)
{
	//ON RECALC ALL
	if (client > MAXPLAYERS)
		CalculatePlayerRank(client); 
	else
	{
		//ON CONNECT
		if (!IsClientInGame(client))
			return;
		new Float: diff = GetEngineTime() - g_fMapStartTime;
		if (GetClientTime(client) < diff)
		{
			CalculatePlayerRank(client); 	
		}
		else
		{
			db_viewPlayerPoints(client);
		}
	}
}	
public SQL_ViewBhopRecordCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	new client = data;
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		g_fPersonalBhopRecord[client] = SQL_FetchFloat(hndl, 2);
		if (g_fPersonalBhopRecord[client] > -1.0)
		{
			decl String:szSteamId[32];
			decl String:szQuery[512];  
			if (client > MAXPLAYERS)
			{
				Format(szSteamId, 32, "%s", g_pr_szSteamID[client]); 
				Format(szQuery, 255, sql_selectPlayerRankBhop, szSteamId);
				SQL_TQuery(g_hDb, SQL_viewBhopRecordCallback2, szQuery, client,DBPrio_Low);
			}
			else
			{
				if (IsClientConnected(client))
				{
					GetClientAuthString(client, szSteamId, 32);
					Format(szQuery, 255, sql_selectPlayerRankBhop, szSteamId);
					SQL_TQuery(g_hDb, SQL_viewBhopRecordCallback2, szQuery, client,DBPrio_Low);
				}
			}
		}
		else
		{
			g_BhopRank[client] = 99999999;
			g_fPersonalBhopRecord[client] = -1.0;
		}
	}
	else
	{
		g_BhopRank[client] = 99999999;
		g_fPersonalBhopRecord[client] = -1.0;
	}
}

public SQL_ViewDropBhopRecordCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	new client = data;
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		g_fPersonalDropBhopRecord[client] = SQL_FetchFloat(hndl, 2);
		if (g_fPersonalDropBhopRecord[client] > -1.0)
		{
			decl String:szSteamId[32];
			decl String:szQuery[512];  
			if (client > MAXPLAYERS)
			{
				Format(szSteamId, 32, "%s", g_pr_szSteamID[client]); 
				Format(szQuery, 255, sql_selectPlayerRankDropBhop, szSteamId);
				SQL_TQuery(g_hDb, SQL_viewDropBhopRecordCallback2, szQuery, client,DBPrio_Low);
			}
			else
			{

				if (IsClientConnected(client))
				{
					GetClientAuthString(client, szSteamId, 32);
					Format(szQuery, 255, sql_selectPlayerRankDropBhop, szSteamId);
					SQL_TQuery(g_hDb, SQL_viewDropBhopRecordCallback2, szQuery, client,DBPrio_Low);
				}
			}
		}
		else
		{
			g_DropBhopRank[client] = 99999999;
			g_fPersonalDropBhopRecord[client] = -1.0;
		}
	}
	else
	{
		g_DropBhopRank[client] = 99999999;
		g_fPersonalDropBhopRecord[client] = -1.0;
	}
}

public SQL_viewDropBhopRecordCallback2(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	new client = data;
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
		g_DropBhopRank[client]= SQL_GetRowCount(hndl);
}

public SQL_ViewWeirdRecordCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	new client = data;
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		g_fPersonalWjRecord[client] = SQL_FetchFloat(hndl, 2);
		if (g_fPersonalWjRecord[client] > -1.0)
		{
			decl String:szSteamId[32];
			decl String:szQuery[512];  
			if (client > MAXPLAYERS)
			{
				Format(szSteamId, 32, "%s", g_pr_szSteamID[client]); 
				Format(szQuery, 255, sql_selectPlayerRankWJ, szSteamId);
				SQL_TQuery(g_hDb, SQL_viewWeirdRecordCallback2, szQuery, client,DBPrio_Low);
			}
			else
			{
				if (IsClientConnected(client))
				{
					GetClientAuthString(client, szSteamId, 32);
					Format(szQuery, 255, sql_selectPlayerRankWJ, szSteamId);
					SQL_TQuery(g_hDb, SQL_viewWeirdRecordCallback2, szQuery, client,DBPrio_Low);
				}
			}
		}
		else
		{
			g_wjRank[client] = 99999999;
			g_fPersonalWjRecord[client] = -1.0;
		}
	}
	else
	{
		g_wjRank[client] = 99999999;
		g_fPersonalWjRecord[client] = -1.0;
	}
}

public SQL_viewWeirdRecordCallback2(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	new client = data;
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
		g_wjRank[client]= SQL_GetRowCount(hndl);
}

public SQL_ViewMultiBhopRecordCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	new client = data;
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		g_fPersonalMultiBhopRecord[client] = SQL_FetchFloat(hndl, 2);
		if (g_fPersonalMultiBhopRecord[client] > -1.0)
		{
			decl String:szSteamId[32];
			decl String:szQuery[512];  
			if (client > MAXPLAYERS)
			{
				Format(szSteamId, 32, "%s", g_pr_szSteamID[client]); 
				Format(szQuery, 255, sql_selectPlayerRankMultiBhop, szSteamId);
				SQL_TQuery(g_hDb, SQL_viewMultiBhopRecordCallback2, szQuery, client,DBPrio_Low);
			}
			else
			{
				if (IsClientConnected(client))
				{
					GetClientAuthString(client, szSteamId, 32);
					Format(szQuery, 255, sql_selectPlayerRankMultiBhop, szSteamId);
					SQL_TQuery(g_hDb, SQL_viewMultiBhopRecordCallback2, szQuery, client,DBPrio_Low);
				}
			}
		}
		else
		{
			g_MultiBhopRank[client] = 99999999;
			g_fPersonalMultiBhopRecord[client] = -1.0;
		}
	}
	else
	{
		g_MultiBhopRank[client] = 99999999;
		g_fPersonalMultiBhopRecord[client] = -1.0;
	}
}

public SQL_viewBhopRecordCallback2(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	new client = data;
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
		g_BhopRank[client]= SQL_GetRowCount(hndl);
}

public SQL_viewMultiBhopRecordCallback2(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	new client = data;
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
		g_MultiBhopRank[client]= SQL_GetRowCount(hndl);
}

//---------------------//
// select player method //
//---------------------//
public db_selectPlayer(client)
{
	decl String:szQuery[255];
	decl String:szSteamId[32];
	if (IsClientConnected(client))
		GetClientAuthString(client, szSteamId, 32);
	else
		return;
	Format(szQuery, 255, sql_selectPlayer, szSteamId, g_szMapName);
	SQL_TQuery(g_hDb, SQL_SelectPlayerCallback, szQuery, client);
}



public db_viewBhopRecord2(client)
{
	decl String:szQuery[512];
	decl String:szSteamId[32];
	if (IsClientConnected(client))
		GetClientAuthString(client, szSteamId, 32);
	else
		return;
	Format(szQuery, 512, sql_selectPlayerJumpBhop, szSteamId);
	SQL_TQuery(g_hDb, SQL_viewBhop2RecordCallback, szQuery, client);
}

public db_viewDropBhopRecord2(client)
{
	decl String:szQuery[512];
	decl String:szSteamId[32];
	if (IsClientConnected(client))
		GetClientAuthString(client, szSteamId, 32);
	else
		return;
	Format(szQuery, 512, sql_selectPlayerJumpDropBhop, szSteamId);
	SQL_TQuery(g_hDb, SQL_viewDropBhop2RecordCallback, szQuery, client);
}

public SQL_viewDropBhop2RecordCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	new client = data;
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		decl String:szQuery[512];
		decl String:szName[MAX_NAME_LENGTH];
		decl String:szSteamId[32];
		SQL_FetchString(hndl, 0, szSteamId, 32);	
		SQL_FetchString(hndl, 1, szName, MAX_NAME_LENGTH);				
		new Handle:pack = CreateDataPack();
		WritePackCell(pack, client);
		WritePackString(pack, szName);		
		Format(szQuery, 512, sql_selectPlayerRankDropBhop, szSteamId);
		SQL_TQuery(g_hDb, SQL_viewDropBhop2RecordCallback2, szQuery, pack);
	}
}

public SQL_viewBhop2RecordCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	new client = data;
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		decl String:szQuery[512];
		decl String:szName[MAX_NAME_LENGTH];
		decl String:szSteamId[32];
		SQL_FetchString(hndl, 0, szSteamId, 32);	
		SQL_FetchString(hndl, 1, szName, MAX_NAME_LENGTH);				
		new Handle:pack = CreateDataPack();
		WritePackCell(pack, client);
		WritePackString(pack, szName);		
		Format(szQuery, 512, sql_selectPlayerRankBhop, szSteamId);
		SQL_TQuery(g_hDb, SQL_viewBhop2RecordCallback2, szQuery, pack);
	}
}

public db_CalculatePlayerCount()
{
	decl String:szQuery[255];
	Format(szQuery, 255, sql_CountRankedPlayers);      
	SQL_TQuery(g_hDb, sql_CountRankedPlayersCallback, szQuery);
}

public db_CalculatePlayerCountBigger0()
{
	decl String:szQuery[255];
	Format(szQuery, 255, sql_CountRankedPlayers2);      
	SQL_TQuery(g_hDb, sql_CountRankedPlayers2Callback, szQuery);
}



public sql_CountRankedPlayersCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		g_pr_players = SQL_FetchInt(hndl, 0);
	}
	else
		g_pr_players=1;	
}

public sql_CountRankedPlayers2Callback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		g_pr_players2 = SQL_FetchInt(hndl, 0);
	}
	else
		g_pr_players2=1;	
}


public SQL_viewBhop2RecordCallback2(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		decl String:szName[MAX_NAME_LENGTH];
		new rank = SQL_GetRowCount(hndl);
		new Handle:pack = data;
		ResetPack(pack);
		new client = ReadPackCell(pack);		
		ReadPackString(pack, szName, MAX_NAME_LENGTH);
		CloseHandle(pack);
		if (rank < 21 && rank < g_BhopRank[client])
		{
			g_BhopRank[client] = rank;
			for(new i = 1; i <= GetMaxClients(); i++) 
			{ 
				if(IsClientInGame(i) && !IsFakeClient(i)) 
				{ 					
					PrintToChat(i, "%t", "Jumpstats_BhopTop", MOSSGREEN, WHITE, YELLOW, szName, rank, g_fPersonalBhopRecord[client]);
					PrintToConsole(i, "[KZ] %s is now #%i in the Bunnyhop Top 20! [%.3f units]", szName, rank, g_fPersonalBhopRecord[client]);
				}
			}
			g_pr_showmsg[client]=true;
			CalculatePlayerRank(client);
		}
	}
}

public SQL_viewDropBhop2RecordCallback2(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		decl String:szName[MAX_NAME_LENGTH];
		new rank = SQL_GetRowCount(hndl);
		new Handle:pack = data;
		ResetPack(pack);
		new client = ReadPackCell(pack);
		ReadPackString(pack, szName, MAX_NAME_LENGTH);	
		CloseHandle(pack);
		if (rank < 21 && rank < g_DropBhopRank[client])
		{
			g_DropBhopRank[client] = rank;
			for(new i = 1; i <= GetMaxClients(); i++) 
			{ 
				if(IsClientInGame(i) && !IsFakeClient(i)) 
				{ 			
					PrintToChat(i, "%t", "Jumpstats_DropBhopTop", MOSSGREEN, WHITE, YELLOW, szName, rank, g_fPersonalDropBhopRecord[client]);
					PrintToConsole(i, "[KZ] %s is now #%i in the Drop-Bunnyhop Top 20! [%.3f units]", szName, rank, g_fPersonalDropBhopRecord[client]);
				}
			}
			g_pr_showmsg[client]=true;
			CalculatePlayerRank(client);
		}
	}
}

public db_viewMultiBhopRecord2(client)
{
	decl String:szQuery[512];
	decl String:szSteamId[32];
	if (IsClientConnected(client))
		GetClientAuthString(client, szSteamId, 32);
	else
		return;
	Format(szQuery, 512, sql_selectPlayerJumpMultiBhop, szSteamId);
	SQL_TQuery(g_hDb, SQL_viewMultiBhop2RecordCallback, szQuery, client);
}

public SQL_viewMultiBhop2RecordCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	new client = data;
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		decl String:szQuery[512];
		decl String:szName[MAX_NAME_LENGTH];
		decl String:szSteamId[32];
		SQL_FetchString(hndl, 0, szSteamId, MAX_NAME_LENGTH);	
		SQL_FetchString(hndl, 1, szName, MAX_NAME_LENGTH);				
		new Handle:pack = CreateDataPack();
		WritePackCell(pack, client);
		WritePackString(pack, szName);		
		Format(szQuery, 512, sql_selectPlayerRankMultiBhop, szSteamId);
		SQL_TQuery(g_hDb, SQL_viewMultiBhop2RecordCallback2, szQuery, pack);
	}
}

public SQL_viewMultiBhop2RecordCallback2(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		decl String:szName[MAX_NAME_LENGTH];
		new rank = SQL_GetRowCount(hndl);
		new Handle:pack = data;
		ResetPack(pack);
		new client = ReadPackCell(pack);
		ReadPackString(pack, szName, MAX_NAME_LENGTH);
		CloseHandle(pack);
		if (rank < 21 && rank < g_MultiBhopRank[client])
		{
			g_MultiBhopRank[client] = rank;
			for(new i = 1; i <= GetMaxClients(); i++) 
			{ 
				if(IsClientInGame(i) && !IsFakeClient(i)) 
				{ 					
					PrintToChat(i, "%t", "Jumpstats_MultiBhopTop", MOSSGREEN, WHITE, YELLOW, szName, rank, g_fPersonalMultiBhopRecord[client]);
					PrintToConsole(i, "[KZ] %s is now #%i in the Multi-Bunnyhop Top 20! [%.3f units]", szName, rank, g_fPersonalMultiBhopRecord[client]);
				}
			}
			g_pr_showmsg[client]=true;
			CalculatePlayerRank(client);
		}
	}
}

public db_viewLjRecord2(client)
{
	decl String:szQuery[512];
	decl String:szSteamId[32];
	if (IsClientConnected(client))
		GetClientAuthString(client, szSteamId, 32);
	else
		return;
	Format(szQuery, 512, sql_selectPlayerJumpLJ, szSteamId);
	SQL_TQuery(g_hDb, SQL_viewLj2RecordCallback, szQuery, client);
}

public SQL_viewLj2RecordCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	new client = data;
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		decl String:szQuery[512];
		decl String:szName[MAX_NAME_LENGTH];
		decl String:szSteamId[32];
		SQL_FetchString(hndl, 0, szSteamId, MAX_NAME_LENGTH);
		SQL_FetchString(hndl, 1, szName, MAX_NAME_LENGTH);	
		new Handle:pack = CreateDataPack();
		WritePackCell(pack, client);
		WritePackString(pack, szName);		
		Format(szQuery, 512, sql_selectPlayerRankLj, szSteamId);
		SQL_TQuery(g_hDb, SQL_viewLj2RecordCallback2, szQuery, pack);
	}
}

public SQL_viewLj2RecordCallback2(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		decl String:szName[MAX_NAME_LENGTH];
		new rank = SQL_GetRowCount(hndl);
		new Handle:pack = data;
		ResetPack(pack);
		new client = ReadPackCell(pack);
		ReadPackString(pack, szName, MAX_NAME_LENGTH);
		CloseHandle(pack);
			
		if (rank < 21 && rank < g_LjRank[client])
		{			
			g_LjRank[client] = rank;
			for(new i = 1; i <= GetMaxClients(); i++) 
			{ 
				if(IsClientInGame(i) && !IsFakeClient(i)) 
				{ 		
					PrintToChat(i, "%t", "Jumpstats_LjTop", MOSSGREEN, WHITE, YELLOW, szName, rank, g_fPersonalLjRecord[client]);
					PrintToConsole(i, "[KZ] %s is now #%i in the Longjump 20! [%.3f units]", szName, rank, g_fPersonalLjRecord[client]);
				}
			}
			g_pr_showmsg[client] = true;
			CalculatePlayerRank(client);		
		}
	}
}

public db_viewWjRecord2(client)
{
	decl String:szQuery[512];
	decl String:szSteamId[32];
	if (IsClientConnected(client))
		GetClientAuthString(client, szSteamId, 32);
	else
		return;
	Format(szQuery, 512, sql_selectPlayerJumpWJ, szSteamId);
	SQL_TQuery(g_hDb, SQL_viewWj2RecordCallback, szQuery, client);
}

public SQL_viewWj2RecordCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	new client = data;
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		decl String:szQuery[512];
		decl String:szName[MAX_NAME_LENGTH];
		decl String:szSteamId[32];
		SQL_FetchString(hndl, 0, szSteamId, MAX_NAME_LENGTH);
		SQL_FetchString(hndl, 1, szName, MAX_NAME_LENGTH);	
		new Handle:pack = CreateDataPack();
		WritePackCell(pack, client);
		WritePackString(pack, szName);		
		Format(szQuery, 512, sql_selectPlayerRankWJ, szSteamId);
		SQL_TQuery(g_hDb, SQL_viewWj2RecordCallback2, szQuery, pack);
	}
}

public SQL_viewWj2RecordCallback2(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		decl String:szName[MAX_NAME_LENGTH];
		new rank = SQL_GetRowCount(hndl);
		new Handle:pack = data;
		ResetPack(pack);
		new client = ReadPackCell(pack);
		ReadPackString(pack, szName, MAX_NAME_LENGTH);
		CloseHandle(pack);
		
		if (rank < 21 && rank < g_wjRank[client])
		{			
			g_wjRank[client] = rank;
			for(new i = 1; i <= GetMaxClients(); i++) 
			{ 
				if(IsClientInGame(i) && !IsFakeClient(i)) 
				{ 		
					PrintToChat(i, "%t", "Jumpstats_WjTop", MOSSGREEN, WHITE, YELLOW, szName, rank, g_fPersonalWjRecord[client]);
					PrintToConsole(i, "[KZ] %s is now #%i in the Weirdjump 20! [%.3f units]", szName, rank, g_fPersonalWjRecord[client]);
				}
			}
			g_pr_showmsg[client] = true;
			CalculatePlayerRank(client);		
		}
	}
}


public db_viewAllRecords(client, String:szSteamId[32])
{
	decl String:szQuery[512];       
	Format(szQuery, 512, sql_selectPersonalAllRecords, szSteamId, szSteamId);  
	SQL_TQuery(g_hDb, SQL_ViewAllRecordsCallback, szQuery, client);
	ProfileMenu(client, -1);
}

public SQL_ViewAllRecordsCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	new client = data;
	new bHeader=false;
	if(SQL_HasResultSet(hndl))
	{	
		new Float:time;
		new teleports;
		decl String:szMapName[128];
		decl String:szMapName2[128];
		decl String:szName[MAX_NAME_LENGTH];
		decl String:szSteamId[32];
		decl String:szRecord_type[4];
		decl String:szQuery[512];
		
		while (SQL_FetchRow(hndl))
		{
			SQL_FetchString(hndl, 0, szName, MAX_NAME_LENGTH);
			SQL_FetchString(hndl, 1, szSteamId, MAX_NAME_LENGTH);
			SQL_FetchString(hndl, 2, szMapName, MAX_MAP_LENGTH);	
			

			time = SQL_FetchFloat(hndl, 3);
			teleports = SQL_FetchInt(hndl, 4);

			if (teleports > 0)
				Format(szRecord_type, 4, "TP");
				else
					Format(szRecord_type, 4, "PRO");	

			//map in rotation?
			for (new i = 0; i < GetArraySize(g_MapList); i++)
			{
				GetArrayString(g_MapList, i, szMapName2, sizeof(szMapName2));
				if (StrEqual(szMapName2, szMapName, false))
				{
					if (!bHeader)
					{
						PrintToConsole(client," ");
						PrintToConsole(client,"-------------");
						PrintToConsole(client,"Map times");
						PrintToConsole(client,"Name: %s", szName);
						PrintToConsole(client,"SteamID: %s", szSteamId);
						PrintToConsole(client,"-------------");
						PrintToConsole(client," ");
						bHeader=true;
						PrintToChat(client, "%t", "ConsoleOutput", LIMEGREEN,WHITE); 	
					}
					new Handle:pack = CreateDataPack();			
					WritePackString(pack, szName);
					WritePackString(pack, szSteamId);
					WritePackString(pack, szMapName);			
					WritePackString(pack, szRecord_type);
					WritePackFloat(pack, time);
					WritePackCell(pack, teleports);
					WritePackCell(pack, client);
					
					if (teleports > 0)
						Format(szQuery, 512, sql_selectPlayerRankTime, szSteamId, szMapName, szMapName);
					else
						Format(szQuery, 512, sql_selectPlayerRankProTime, szSteamId, szMapName, szMapName);
					SQL_TQuery(g_hDb, SQL_ViewAllRecordsCallback2, szQuery, pack);			
					continue;
				}
			}			
		}
	}
	if(!bHeader)
	{
		ProfileMenu(client, -1);
		PrintToChat(client, "%t", "PlayerHasNoMapRecords", LIMEGREEN,WHITE,g_szProfileName[client]);
	}
}
public SQL_ViewAllRecordsCallback2(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		decl String:szQuery[512];
		new rank = SQL_GetRowCount(hndl);
		new Handle:pack = data;
		WritePackCell(pack, rank);
		ResetPack(pack);
		decl String:szName[MAX_NAME_LENGTH];
		ReadPackString(pack, szName, MAX_NAME_LENGTH);
		decl String:szSteamId[32];
		ReadPackString(pack, szSteamId, 32);
		decl String:szMapName[MAX_MAP_LENGTH];
		ReadPackString(pack, szMapName, MAX_MAP_LENGTH);
		decl String:szRecord_type[4];
		ReadPackString(pack, szRecord_type, 4);	
		new teleports = ReadPackCell(pack);
		
		if (teleports > 0)
			Format(szQuery, 512, sql_selectPlayerCount, szMapName);
		else
			Format(szQuery, 512, sql_selectPlayerProCount, szMapName);
		SQL_TQuery(g_hDb, SQL_ViewAllRecordsCallback3, szQuery, pack);
	}
}

public SQL_ViewAllRecordsCallback3(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	//if there is a player record
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		new count = SQL_GetRowCount(hndl);
		new Handle:pack = data;
		ResetPack(pack);
		
		decl String:szName[MAX_NAME_LENGTH];
		ReadPackString(pack, szName, MAX_NAME_LENGTH);
		decl String:szSteamId[32];
		ReadPackString(pack, szSteamId, 32);
		decl String:szMapName[MAX_MAP_LENGTH];
		ReadPackString(pack, szMapName, MAX_MAP_LENGTH);	
		decl String:szRecord_type[4];
		ReadPackString(pack, szRecord_type, 4);	
		new Float:time = ReadPackFloat(pack);		
		new teleports = ReadPackCell(pack);
		new client = ReadPackCell(pack);
		new rank = ReadPackCell(pack);
		
		CloseHandle(pack);
		FormatTimeFloat(client,time,3);
		PrintToConsole(client,"%s, Time: %s (%s), Teleports: %i, Rank: %i/%i", szMapName, g_szTime[client], szRecord_type, teleports,rank,count);
	}
}	
		
public db_viewPlayerRank(client, String:szSteamId[32])
{
	decl String:szQuery[512];  
	Format(g_pr_szrank[client], 512, "");	
	Format(szQuery, 512, sql_selectRankedPlayer, szSteamId);  
	SQL_TQuery(g_hDb, SQL_ViewRankedPlayerCallback, szQuery, client);
}

public SQL_ViewRankedPlayerCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	new client = data;
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{	
		decl String:szQuery[512];
		decl String:szName[MAX_NAME_LENGTH];
		decl String:szCountry[100];
		decl String:szSteamId[32];
		new finishedmapstp;
		new finishedmapspro;
		new points;
		new wonc;
		new pointsc;
		g_tprecords[client] = 0;	
		g_prorecords[client] = 0;	
		
		//get the result
		SQL_FetchString(hndl, 0, szSteamId, 32);
		SQL_FetchString(hndl, 1, szName, MAX_NAME_LENGTH);
		points = SQL_FetchInt(hndl, 2);
		finishedmapstp = SQL_FetchInt(hndl, 3);      
		finishedmapspro = SQL_FetchInt(hndl, 4);
		wonc = SQL_FetchInt(hndl, 6);
		pointsc = SQL_FetchInt(hndl, 7);
		SQL_FetchString(hndl, 8, szCountry, 100);
		
		new Handle:pack_pr = CreateDataPack();
		
		WritePackString(pack_pr, szName);
		WritePackString(pack_pr, szSteamId);	
		WritePackCell(pack_pr, client);		
		WritePackCell(pack_pr, points);
		WritePackCell(pack_pr, finishedmapstp);
		WritePackCell(pack_pr, finishedmapspro);
		WritePackCell(pack_pr, wonc);
		WritePackCell(pack_pr, pointsc);
		WritePackString(pack_pr, szCountry);	
		Format(szQuery, 512, sql_selectRankedPlayersRank, szSteamId);
		SQL_TQuery(g_hDb, SQL_ViewRankedPlayerCallback2, szQuery, pack_pr);
	}
}

public SQL_ViewRankedPlayerCallback2(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		decl String:szQuery[512];
		decl String:szSteamId[32];
		decl String:szName[MAX_NAME_LENGTH];
		new rank = SQL_GetRowCount(hndl);
		new Handle:pack_pr = data;
		WritePackCell(pack_pr, rank);
		ResetPack(pack_pr);	        
		ReadPackString(pack_pr, szName, MAX_NAME_LENGTH);
		ReadPackString(pack_pr, szSteamId, 32);	
		Format(szQuery, 512, sql_selectTpRecordCount, szSteamId);
		SQL_TQuery(g_hDb, SQL_ViewRankedPlayerCallback3, szQuery, pack_pr);	
	}
}

public SQL_ViewRankedPlayerCallback3(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	new Handle:pack_pr = data;
	decl String:szQuery[512];
	decl String:szSteamId[32];
	decl String:szName[MAX_NAME_LENGTH];
	ResetPack(pack_pr);	        
	ReadPackString(pack_pr, szName, MAX_NAME_LENGTH);
	ReadPackString(pack_pr, szSteamId, 32);	
	new client = ReadPackCell(pack_pr);    
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl)) 
		g_tprecords[client] = SQL_FetchInt(hndl, 1);	//pack full?´
	Format(szQuery, 512, sql_selectProRecordCount, szSteamId);
	SQL_TQuery(g_hDb, SQL_ViewRankedPlayerCallback4, szQuery, pack_pr);		
}

public SQL_ViewRankedPlayerCallback4(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	decl String:szQuery[512];
	decl String:szSteamId[32];
	decl String:szName[MAX_NAME_LENGTH];
	new Handle:pack_pr = data;
	ResetPack(pack_pr);       
	ReadPackString(pack_pr, szName, MAX_NAME_LENGTH);
	ReadPackString(pack_pr, szSteamId, 32);		
	new client = ReadPackCell(pack_pr);  
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl)) 
		g_prorecords[client] = SQL_FetchInt(hndl, 1);	//pack full?
	Format(szQuery, 512, sql_selectChallenges, szSteamId,szSteamId);
	SQL_TQuery(g_hDb, SQL_ViewRankedPlayerCallback5, szQuery, pack_pr);		
}

public SQL_ViewRankedPlayerCallback5(Handle:owner, Handle:hndl, const String:error[], any:data)
{	
	new challenges = 0;
	decl String:szChallengesPoints[32];
	Format(szChallengesPoints, 32, "0p")
	decl String:szChallengesWinRatio[32];
	Format(szChallengesWinRatio, 32, "0")
	new Handle:pack_pr = data;
	decl String:szName[MAX_NAME_LENGTH];
	decl String:szSteamId[32];
	decl String:szCountry[100];
	decl String:szNextRank[32];
	decl String:szSkillGroup[32];
	ResetPack(pack_pr);     
	ReadPackString(pack_pr, szName, MAX_NAME_LENGTH);
	ReadPackString(pack_pr, szSteamId, 32);
	new client = ReadPackCell(pack_pr);       
	new points = ReadPackCell(pack_pr);
	new finishedmapstp = ReadPackCell(pack_pr);
	new finishedmapspro = ReadPackCell(pack_pr);  
	new challengeswon= ReadPackCell(pack_pr);  
	new challengespoints= ReadPackCell(pack_pr);  
	ReadPackString(pack_pr, szCountry, 100);	
	new rank = ReadPackCell(pack_pr);
	new tprecords = g_tprecords[client];
	new prorecords = g_prorecords[client];
	Format(g_szProfileSteamId[client], 32, "%s", szSteamId);
	Format(g_szProfileName[client], MAX_NAME_LENGTH, "%s", szName);
	new bool:master=false;
	new RankDifference;		   
	
	
	//profile not refreshed after removing maps?
	if (finishedmapstp > g_pr_mapcount)
		finishedmapstp=g_pr_mapcount;
	if (finishedmapspro > g_pr_mapcount)	
		finishedmapspro=g_pr_mapcount;
		
	if (points < g_pr_rank_Novice)
	{
		Format(szSkillGroup, 32, "Newbie");
		RankDifference = g_pr_rank_Novice - points;
		Format(szNextRank, 32, " (Novice)");
	}
	else
	if (g_pr_rank_Novice <= points && points < g_pr_rank_Scrub)
	{
		Format(szSkillGroup, 32, "Novice");
		RankDifference = g_pr_rank_Scrub - points;
		Format(szNextRank, 32, " (Scrub)");
	}
	else
	if (g_pr_rank_Scrub <= points && points < g_pr_rank_Rookie)
	{
		Format(szSkillGroup, 32, "Scrub");
		RankDifference = g_pr_rank_Rookie - points;
		Format(szNextRank, 32, " (Rookie)");
	}
		   
	else
	if (g_pr_rank_Rookie <= points && points < g_pr_rank_Skilled)
	{
		Format(szSkillGroup, 32, "Rookie");
		RankDifference = g_pr_rank_Skilled - points;
		Format(szNextRank, 32, " (Skilled)");
	}                      
	else
	if (g_pr_rank_Skilled <= points && points < g_pr_rank_Expert)
	{
	   Format(szSkillGroup, 32, "Skilled");
	   RankDifference = g_pr_rank_Expert - points;
	   Format(szNextRank, 32, " (Expert)");
	}                      
	else
	if (g_pr_rank_Expert <= points && points < g_pr_rank_Pro)
	{
	   Format(szSkillGroup, 32, "Expert");
	   RankDifference = g_pr_rank_Pro - points;
	   Format(szNextRank, 32, " (Pro)");
	}
	else
	if (g_pr_rank_Pro <= points && points < g_pr_rank_Elite)
	{
		Format(szSkillGroup, 32, "Pro");
		RankDifference = g_pr_rank_Elite - points;
		Format(szNextRank, 32, " (Elite)");
	}
	else
	if (g_pr_rank_Elite <= points && points < g_pr_rank_Master)
	{
		Format(szSkillGroup, 32, "Elite");    
		RankDifference = g_pr_rank_Master - points;
		Format(szNextRank, 32, " (Master)");
	}
	else
	if (points >= g_pr_rank_Master)
	{
		Format(szSkillGroup, 32, "Master");    
		RankDifference = 0;
		Format(szNextRank, 32, "");
		master=true;
	}  

	if(SQL_HasResultSet(hndl))
	{		
		challenges= SQL_GetRowCount(hndl);
	}	
	
	if (challengespoints>0)
		Format(szChallengesPoints, 32, "+%ip",challengespoints);   
	else
		if (challengespoints<0)
			Format(szChallengesPoints, 32, "%ip",challengespoints); 

	if (challengeswon>0)
		Format(szChallengesWinRatio, 32, "+%i",challengeswon);   
	else
		if (challengeswon<0)
			Format(szChallengesWinRatio, 32, "%i",challengeswon); 
			
	if (master==false)
	{	
		if (g_bAllowCheckpoints)
			Format(g_pr_szrank[client], 512, "Rank %i/%i\nPoints: %ip (%s)\nNext rank in: %ip%s\nPro times: %i/%i (records: %i)\nTP times: %i/%i (records: %i)\nPlayed challenges: %i\n╘W/L Ratio: %s\n╘W/L Points Ratio: %s\n ", rank,g_pr_players,points,szSkillGroup,RankDifference,szNextRank,finishedmapspro,g_pr_mapcount,prorecords,finishedmapstp,g_pr_mapcount,tprecords,challenges,szChallengesWinRatio,szChallengesPoints);                    
		else
			Format(g_pr_szrank[client], 512, "Rank %i/%i\nPoints: %ip (%s)\nNext rank in: %ip%s\nMaps completed: %i/%i (records: %i)\nPlayed challenges: %i\n╘W/L Ratio: %s\n╘W/L Points Ratio: %s\n ", rank,g_pr_players,points,szSkillGroup,RankDifference,szNextRank,finishedmapspro,g_pr_mapcount,prorecords,challenges,szChallengesWinRatio,szChallengesPoints);                    	
	}
	else
	{
		if (g_bAllowCheckpoints)
			Format(g_pr_szrank[client], 512, "Rank %i/%i\nPoints: %ip (%s)\nPro times: %i/%i (records: %i)\nTP times: %i/%i (records: %i)\nPlayed challenges: %i\n╘ W/L Ratio: %s\n╘ W/L Points Ratio: %s\n ", rank,g_pr_players,points,szSkillGroup,finishedmapspro,g_pr_mapcount,prorecords,finishedmapstp,g_pr_mapcount,tprecords,challenges,szChallengesWinRatio,szChallengesPoints);                    
		else
			Format(g_pr_szrank[client], 512, "Rank %i/%i\nPoints: %ip (%s)\nMaps completed: %i/%i (records: %i)\nPlayed challenges: %i\n╘ W/L Ratio: %s\n╘ W/L Points Ratio: %s\n ", rank,g_pr_players,points,szSkillGroup,finishedmapspro,g_pr_mapcount,prorecords,challenges,szChallengesWinRatio,szChallengesPoints);                    
		
	}
	decl String:szTitle[512];
	if (g_bCountry)
		Format(szTitle, 512, "Player: %s\nID: %s\nNationality: %s\n \n%s\n",  szName,szSteamId,szCountry,g_pr_szrank[client]);		
	else
		Format(szTitle, 512, "Player: %s\nID: %s\n \n%s\n",  szName,szSteamId,g_pr_szrank[client]);				
		
	new Handle:menu = CreateMenu(ProfileMenuHandler);
	SetMenuTitle(menu, szTitle);
	AddMenuItem(menu, "Current map time", "Current map time");
	AddMenuItem(menu, "All map times", "All map times");
	AddMenuItem(menu, "Jumpstats", "Jumpstats");
		   
	decl String:szcSteamId[32];
	if (IsClientConnected(client))
	{
		GetClientAuthString(client, szcSteamId, 32);  
		if(StrEqual(szSteamId,szcSteamId))
				AddMenuItem(menu, "Refresh my profile", "Refresh my profile");
	}
	SetMenuOptionFlags(menu, MENUFLAG_BUTTON_EXIT);
	DisplayMenu(menu, client, MENU_TIME_FOREVER);
	g_bClimbersMenuOpen[client]=false;
	g_bMenuOpen[client]=true;
	CloseHandle(pack_pr);	
}


public db_viewRecord(client, String:szSteamId[32], String:szMapName[MAX_MAP_LENGTH])
{
	decl String:szQuery[512];       
	Format(szQuery, 512, sql_selectPersonalRecords, szSteamId, szMapName);  
	SQL_TQuery(g_hDb, SQL_ViewRecordCallback, szQuery, client);
}

public SQL_ViewRecordCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	new client = data;	
	g_bClimbersMenuOpen[client]=false;
	g_bMenuOpen[client] = true;	
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		
		decl String:szQuery[512];
		decl String:szMapName[MAX_MAP_LENGTH];
		decl String:szName[MAX_NAME_LENGTH];
		decl String:szSteamId[32];
		new Float:time;
		new Float:timepro;
		new teleports;
        
		//get the result
		SQL_FetchString(hndl, 0, szMapName, MAX_MAP_LENGTH);
		SQL_FetchString(hndl, 1, szSteamId, MAX_NAME_LENGTH);
		SQL_FetchString(hndl, 2, szName, MAX_NAME_LENGTH);
		time = SQL_FetchFloat(hndl, 3);
		timepro = SQL_FetchFloat(hndl, 4);      
		teleports = SQL_FetchInt(hndl, 5);
		new Handle:pack1 = CreateDataPack();		
		WritePackString(pack1, szMapName);
		WritePackString(pack1, szSteamId);	
		WritePackString(pack1, szName);	
		WritePackFloat(pack1, time);
		WritePackCell(pack1, client);
		WritePackFloat(pack1, timepro);
		WritePackCell(pack1, teleports);
		
		if (SQL_FetchInt(hndl, 3) != -1.0)
			Format(szQuery, 512, sql_selectPlayerRankTime, szSteamId, szMapName, szMapName);
		else
			Format(szQuery, 512, sql_selectPlayerRankProTime, szSteamId, szMapName, szMapName);
		SQL_TQuery(g_hDb, SQL_ViewRecordCallback2, szQuery, pack1);
	}
	else
	{ 
		new Handle:panel = CreatePanel();
		DrawPanelText(panel, "Current map time");
		DrawPanelText(panel, " ");
		DrawPanelText(panel, "No record found on this map.");
		DrawPanelItem(panel, "exit");
		SendPanelToClient(panel, client, MenuHandler2, 300);
		CloseHandle(panel);
	}
}

public SQL_ViewRecordCallback2(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
	decl String:szQuery[512];
	new rank = SQL_GetRowCount(hndl);
	new Handle:pack2 = data;
	WritePackCell(pack2, rank);
	ResetPack(pack2);	
	decl String:szMapName[MAX_MAP_LENGTH];
	ReadPackString(pack2, szMapName, MAX_MAP_LENGTH);
	decl String:szSteamId[32];
	ReadPackString(pack2, szSteamId, 32);
	decl String:szName[MAX_NAME_LENGTH];
	ReadPackString(pack2, szName, MAX_NAME_LENGTH);
	new Float:time = ReadPackFloat(pack2);
	if (time != -1.0)
		Format(szQuery, 512, sql_selectPlayerCount, szMapName);
	else
		Format(szQuery, 512, sql_selectPlayerProCount, szMapName);
	SQL_TQuery(g_hDb, SQL_ViewRecordCallback3, szQuery, pack2);
	}
}

//----------//
// callback //
//----------//
public SQL_ViewRecordCallback3(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	//if there is a player record
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		new count1 = SQL_GetRowCount(hndl);
		new Handle:pack3 = data;
		ResetPack(pack3);		
		decl String:szMapName[MAX_MAP_LENGTH];
		ReadPackString(pack3, szMapName, MAX_MAP_LENGTH);
		decl String:szSteamId[32];
		ReadPackString(pack3, szSteamId, 32);
		decl String:szName[MAX_NAME_LENGTH];
		ReadPackString(pack3, szName, MAX_NAME_LENGTH);	
		new Float:time = ReadPackFloat(pack3);
		new client = ReadPackCell(pack3);
		new Float:timepro = ReadPackFloat(pack3);
		new teleports = ReadPackCell(pack3);
		new rank = ReadPackCell(pack3);
		g_bClimbersMenuOpen[client]=false;
		g_bMenuOpen[client] = true;	
		if (time != -1.0 && timepro == -1.0)
		{
			new Handle:panel = CreatePanel();
			decl String:szVrName[256];
			decl String:szVrTime[256];
			Format(szVrName, 256, "Map time of %s", szName);
			DrawPanelText(panel, szVrName);
			Format(szVrName, 256, "on %s", g_szMapName);
			DrawPanelText(panel, szVrName);
			DrawPanelText(panel, " ");
			decl String:szVrTeleports[16];
			decl String:szVrRank[16];			
			
			FormatTimeFloat(client, time, 3);
			Format(szVrTime, 256, "Time: %s", g_szTime[client]);
			
			Format(szVrTeleports, 16, "Teleports: %i", teleports);
			Format(szVrRank, 32, "Rank: %i of %i", rank,count1);                  
			DrawPanelText(panel, "TP Record:");
			DrawPanelText(panel, szVrTime);
			DrawPanelText(panel, szVrTeleports);
			DrawPanelText(panel, szVrRank);
			DrawPanelText(panel, " ");
			DrawPanelText(panel, "Pro Record:");
			DrawPanelText(panel, "-");
			DrawPanelText(panel, " ");
			DrawPanelItem(panel, "exit");
			CloseHandle(pack3);
			SendPanelToClient(panel, client, RecordPanelHandler, 300);
			CloseHandle(panel);                 
		}
		else
			if (time == -1.0 && timepro != -1.0)
			{               
				new Handle:panel = CreatePanel();
				decl String:szVrName[256];
				decl String:szVrTime[256];
				Format(szVrName, 256, "Map time of %s", szName);
				DrawPanelText(panel, szVrName);
				Format(szVrName, 256, "on %s", g_szMapName);
				DrawPanelText(panel, " ");		
				decl String:szVrRank[16];
				
				FormatTimeFloat(client, timepro, 3);
				Format(szVrTime, 256, "Time: %s", g_szTime[client]);

				Format(szVrRank, 32, "Rank: %i of %i", rank,count1);
				DrawPanelText(panel, "TP Record:");
				DrawPanelText(panel, "-");
				DrawPanelText(panel, " ");
				DrawPanelText(panel, "Pro Record:");
				DrawPanelText(panel, g_szTime[client]);
				DrawPanelText(panel, szVrRank);
				DrawPanelText(panel, " ");
				DrawPanelItem(panel, "exit");
				CloseHandle(pack3);
				SendPanelToClient(panel, client, RecordPanelHandler, 300);
				CloseHandle(panel);
			}
			else
				if (time != 0.000000 && timepro != 0.000000)
				{
					WritePackCell(pack3, count1);
					decl String:szQuery[512];
					Format(szQuery, 512, sql_selectPlayerRankProTime, szSteamId, szMapName, szMapName);
					SQL_TQuery(g_hDb, SQL_ViewRecordCallback4, szQuery, pack3);
                }
        }
}

public SQL_ViewRecordCallback4(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{

		decl String:szQuery[512];
		new rankPro = SQL_GetRowCount(hndl);
		new Handle:pack4 = data;
		WritePackCell(pack4, rankPro);
		ResetPack(pack4);
		decl String:szMapName[MAX_MAP_LENGTH];
		ReadPackString(pack4, szMapName, MAX_MAP_LENGTH);
		Format(szQuery, 512, sql_selectPlayerProCount, szMapName);
		SQL_TQuery(g_hDb, SQL_ViewRecordCallback5, szQuery, pack4);
	}
}

public SQL_ViewRecordCallback5(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	//if there is a player record
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		new countPro = SQL_GetRowCount(hndl);           
		//retrieve all values
		new Handle:pack5 = data;
		ResetPack(pack5);            
		decl String:szMapName[MAX_MAP_LENGTH];
		ReadPackString(pack5, szMapName, MAX_MAP_LENGTH);
		decl String:szSteamId[32];
		ReadPackString(pack5, szSteamId, 32);
		decl String:szName[MAX_NAME_LENGTH];
		ReadPackString(pack5, szName, MAX_NAME_LENGTH);	
		new Float:time = ReadPackFloat(pack5);
		new client = ReadPackCell(pack5);
		new Float:timepro = ReadPackFloat(pack5);
		new teleports = ReadPackCell(pack5);
		new rank = ReadPackCell(pack5);                  
		new count1 = ReadPackCell(pack5);        
		new rankPro = ReadPackCell(pack5);                 
		g_bClimbersMenuOpen[client]=false;
		g_bMenuOpen[client] = true;			
		if (time != -1.0 && timepro != -1.0)
		{				
			new Handle:panel = CreatePanel();
			decl String:szVrName[256];
			Format(szVrName, 256, "Map time of %s", szName);
			DrawPanelText(panel, szVrName);
			Format(szVrName, 256, "on %s", g_szMapName);
			DrawPanelText(panel, " ");
			
			decl String:szVrTeleports[16];
			decl String:szVrRank[16];
			decl String:szVrRankPro[16];      
			decl String:szVrTime[256];
			decl String:szVrTimePro[256];
			FormatTimeFloat(client, time, 3);	
			Format(szVrTime, 256, "Time: %s",g_szTime[client]);
			FormatTimeFloat(client, timepro, 3);
			Format(szVrTimePro, 256, "Time: %s", g_szTime[client]);
			
			Format(szVrTeleports, 16, "Teleports: %i", teleports); 
			Format(szVrRank, 32, "Rank: %i of %i", rank,count1); 
			Format(szVrRankPro, 32, "Rank: %i of %i", rankPro,countPro); 
					          
			DrawPanelText(panel, "TP Record:");
			DrawPanelText(panel, szVrTime);
			DrawPanelText(panel, szVrTeleports);
			DrawPanelText(panel, szVrRank);
			DrawPanelText(panel, " ");
			DrawPanelText(panel, "Pro Record:");
			DrawPanelText(panel, szVrTimePro);
			DrawPanelText(panel, szVrRankPro);
			DrawPanelText(panel, " ");
			DrawPanelItem(panel, "exit");
			SendPanelToClient(panel, client, RecordPanelHandler, 300);
			CloseHandle(panel);
		}
		CloseHandle(pack5);
	}
	
}

//PROFILE
public db_viewPlayerAll(client, String:szPlayerName[MAX_NAME_LENGTH])
{
	decl String:szQuery[512];
	decl String:szName[MAX_NAME_LENGTH*2+1];
	SQL_QuoteString(g_hDb, szPlayerName, szName, MAX_NAME_LENGTH*2+1);      
	Format(szQuery, 512, sql_selectPlayerRankAll, szName);
	SQL_TQuery(g_hDb, SQL_ViewPlayerAllCallback, szQuery, client);
}

public SQL_ViewPlayerAllCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{    
	new client = data;  
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{           
		SQL_FetchString(hndl, 1, g_szProfileSteamId[client], 32);
		db_viewPlayerRank(client,g_szProfileSteamId[client]);
	}
	else
		PrintToChat(client, "%t", "PlayerNotFound", MOSSGREEN,WHITE, g_szProfileName[client]);
}

public ProfileMenuHandler(Handle:menu, MenuAction:action, param1,param2)
{ 
	if(action == MenuAction_Select)
	{
		switch(param2)
		{
			case 0: db_viewRecord(param1, g_szProfileSteamId[param1], g_szMapName);
			case 1: db_viewAllRecords(param1, g_szProfileSteamId[param1]);
			case 2: db_viewJumpStats(param1, g_szProfileSteamId[param1]);			
		}	
		if (param2==2 && !g_bJumpStats)
			PrintToChat(param1, "%t", "JumpstatsDisabled",MOSSGREEN,WHITE);
		if (param2==3)
		{
			if(g_brc_PlayerRank[param1])
			{
				PrintToChat(param1, "%t", "PrUpdateInProgress", MOSSGREEN,WHITE);
			}
			else
			{
			
				g_brc_PlayerRank[param1]=true;
				PrintToChat(param1, "%t", "Rc_PlayerRankStart", MOSSGREEN,WHITE,GRAY);
				CalculatePlayerRank(param1);
			}
		}
	}
	else
	if(action == MenuAction_Cancel)
	{
		if (1 <= param1 <= MaxClients && IsClientInGame(param1))
		{
			switch(detailView[param1])
			{
				case 0: db_selectTopPlayers(param1);
				case 1: db_selectTopClimbers(param1);
				case 2: db_selectTopLj(param1);	
				case 3: db_selectTopChallengers(param1);
				case 4: db_selectTopWj(param1);
				case 5: db_selectTopBhop(param1);
				case 6: db_selectTopDropBhop(param1);	
				case 7: db_selectTopMultiBhop(param1);	
				case 8: db_selectTPClimbers(param1);	
				case 9: db_selectProClimbers(param1);	
				case 10: db_selectTopTpRecordHolders(param1);
				case 11: db_selectTopProRecordHolders(param1);	
			}	
			if (detailView[param1] < 0)		
			{
				if (g_bSelectProfile[param1])
					ProfileMenu(param1,0);
				else
					g_bMenuOpen[param1]=false;	
			}
		}							
	}
	else 
		if (action == MenuAction_End)	
		{
			CloseHandle(menu);
		}
}

public db_selectRecord(client)
{
	decl String:szQuery[255];
	decl String:szSteamId[32];
	if (IsClientConnected(client))
		GetClientAuthString(client, szSteamId, 32);
	else
		return;
	Format(szQuery, 255, sql_selectRecord, szSteamId, g_szMapName);
	SQL_TQuery(g_hDb, sql_selectRecordCallback, szQuery, client);
}

public sql_selectRecordCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	new client = data;
	decl String:szQuery[512];
	decl String:szSteamId[32];
	if (IsClientConnected(client))
		GetClientAuthString(client, szSteamId, 32);
	else
		return;
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		if	(g_OverallTp[client]>0)
			Format(szQuery, 512, sql_selectRecordTp, szSteamId, g_szMapName);
		else
			Format(szQuery, 512, sql_selectProRecord, szSteamId, g_szMapName);
		if (!IsFakeClient(client))
			SQL_TQuery(g_hDb, SQL_UpdateRecordCallback, szQuery, client);		
	}
	else
	{
		decl String:szName[MAX_NAME_LENGTH];
		GetClientName(client, szName, MAX_NAME_LENGTH);
		if	(g_OverallTp[client]>0)
		{						
			Format(szQuery, 512, sql_insertPlayerTp, szSteamId, g_szMapName, szName, g_fFinalTime[client], g_OverallTp[client]);
			g_fPersonalRecord[client] = g_fFinalTime[client];	
			SQL_TQuery(g_hDb, SQL_UpdateRecordTpCallback, szQuery,client);	
		}
		else
		{
			Format(szQuery, 512, sql_insertPlayerPro, szSteamId, g_szMapName, szName, g_fFinalTime[client]);
			g_fPersonalRecordPro[client] = g_fFinalTime[client];
			SQL_TQuery(g_hDb, SQL_UpdateRecordProCallback, szQuery,client);	
		}
			
	}
}

public db_updatePlayerOptions(client, String:szSteamId[32])
{
	decl String:szQuery[512];
	Format(szQuery, 512, sql_updatePlayerOptions, BooltoInt(g_bColorChat[client]),BooltoInt(g_bInfoPanel[client]),BooltoInt(g_bClimbersMenuSounds[client]),	BooltoInt(g_bEnableQuakeSounds[client]), BooltoInt(g_bAutoBhopClient[client]),BooltoInt(g_bShowNames[client]),BooltoInt(g_bGoToClient[client]),BooltoInt(g_bStrafeSync[client]),BooltoInt(g_bShowTime[client]),BooltoInt(g_bHide[client]),BooltoInt(g_bShowSpecs[client]),BooltoInt(g_bCPTextMessage[client]),BooltoInt(g_bAdvancedClimbersMenu[client]),"weapon_knife",BooltoInt(g_bJumpPenalty[client]),0,0,0,szSteamId);
	SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery, client,DBPrio_Low);
}
		
public db_updateLjRecord(client)
{
	decl String:szQuery[255];
	decl String:szSteamId[32];
	if (IsClientConnected(client))
		GetClientAuthString(client, szSteamId, 32);
	else
		return;
	Format(szQuery, 255, sql_selectPlayerJumpLJ, szSteamId);
	if (!IsFakeClient(client))
		SQL_TQuery(g_hDb, SQL_UpdateLjRecordCallback, szQuery, client,DBPrio_Low);
}
public db_updateWjRecord(client)
{
	decl String:szQuery[255];
	decl String:szSteamId[32];
	if (IsClientConnected(client))
		GetClientAuthString(client, szSteamId, 32);
	else
		return;
	Format(szQuery, 255, sql_selectPlayerJumpWJ, szSteamId);
	if (!IsFakeClient(client))
		SQL_TQuery(g_hDb, SQL_UpdateWjRecordCallback, szQuery, client,DBPrio_Low);
}

public db_updateBhopRecord(client)
{
	decl String:szQuery[255];
	decl String:szSteamId[32];
	if (IsClientConnected(client))
		GetClientAuthString(client, szSteamId, 32);
	else
		return;
	Format(szQuery, 255, sql_selectPlayerJumpBhop, szSteamId);
	if (!IsFakeClient(client))
		SQL_TQuery(g_hDb, SQL_UpdateBhopRecordCallback, szQuery, client,DBPrio_Low);
}

public db_updateDropBhopRecord(client)
{
	decl String:szQuery[255];
	decl String:szSteamId[32];
	if (IsClientConnected(client))
		GetClientAuthString(client, szSteamId, 32);
	else
		return;
	Format(szQuery, 255, sql_selectPlayerJumpDropBhop, szSteamId);
	if (!IsFakeClient(client))
		SQL_TQuery(g_hDb, SQL_UpdateDropBhopRecordCallback, szQuery, client,DBPrio_Low);
}

public db_updateMultiBhopRecord(client)
{
	decl String:szQuery[255];
	decl String:szSteamId[32];
	if (IsClientConnected(client))
		GetClientAuthString(client, szSteamId, 32);
	else
		return;
	Format(szQuery, 255, sql_selectPlayerJumpMultiBhop, szSteamId);
	if (!IsFakeClient(client))
		SQL_TQuery(g_hDb, SQL_UpdateMultiBhopRecordCallback, szQuery, client,DBPrio_Low);
}

public db_updateMapButtons(Float:loc0, Float:loc1, Float:loc2, Float:ang0, index)
{
	decl String:szQuery[255];
	new Handle:pack = CreateDataPack();
	WritePackFloat(pack, loc0);
	WritePackFloat(pack, loc1);
	WritePackFloat(pack, loc2);
	WritePackFloat(pack, ang0);
	WritePackCell(pack, index);
	Format(szQuery, 255, sql_selectMapButtons, g_szMapName);
	SQL_TQuery(g_hDb, SQL_selectMapButtonsCallback, szQuery, pack);
}

public SQL_selectMapButtonsCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	decl String:szQuery[512];
	new Handle:pack = data;
	ResetPack(pack);
	new Float:loc0 = ReadPackFloat(pack);
	new Float:loc1 = ReadPackFloat(pack);
	new Float:loc2 = ReadPackFloat(pack);
	new Float:ang0 = ReadPackFloat(pack);
	new index = ReadPackCell(pack);
	CloseHandle(pack);
	
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		if (index==0)
			Format(szQuery, 512, sql_updateMapButtonsStart, loc0,loc1,loc2,ang0, g_szMapName);
		else
			Format(szQuery, 512, sql_updateMapButtonsEnd, loc0,loc1,loc2,ang0, g_szMapName);
		SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery,DBPrio_Low);
	}
	else
	{
		if (index==0)
			Format(szQuery, 512, sql_insertMapButtons, g_szMapName,loc0,loc1,loc2,-1.0,-1.0,-1.0,ang0,-1.0);
		else
			Format(szQuery, 512, sql_insertMapButtons, g_szMapName,-1.0,-1.0,-1.0,loc0,loc1,loc2,-1.0,ang0);
		SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery,DBPrio_Low);
	}
}


public SQL_UpdateLjRecordCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	new client = data;
	if (IsClientConnected(client))
	{
		decl String:szQuery[512];
		decl String:szUName[MAX_NAME_LENGTH];
		GetClientName(client, szUName, MAX_NAME_LENGTH);
		decl String:szSteamId[32];
		GetClientAuthString(client, szSteamId, 32);
		decl String:szName[MAX_NAME_LENGTH*2+1];
		SQL_QuoteString(g_hDb, szUName, szName, MAX_NAME_LENGTH*2+1);
		if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
		{
			Format(szQuery, 512, sql_updateLj, szName, g_fPersonalLjRecord[client], g_fPreStrafe[client], g_fMaxSpeed2[client], g_Strafes[client],g_sync[client],g_flastHeight[client], szSteamId);
			SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery,DBPrio_Low);
		}	
		else
		{
			Format(szQuery, 512, sql_insertPlayerJumpLj, szSteamId, szName, g_fPersonalLjRecord[client], g_fPreStrafe[client], g_fMaxSpeed2[client], g_Strafes[client],g_sync[client],g_flastHeight[client]);
			SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery,DBPrio_Low);
		}
		db_viewLjRecord2(client);
	}
}

public SQL_UpdateWjRecordCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	new client = data;
	if (IsClientInGame(client))
	{
		decl String:szQuery[512];
		decl String:szUName[MAX_NAME_LENGTH];
		GetClientName(client, szUName, MAX_NAME_LENGTH);
		decl String:szSteamId[32];
		GetClientAuthString(client, szSteamId, 32);
		decl String:szName[MAX_NAME_LENGTH*2+1];
		SQL_QuoteString(g_hDb, szUName, szName, MAX_NAME_LENGTH*2+1);
		if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
		{
			Format(szQuery, 512, sql_updateWJ, szName, g_fPersonalWjRecord[client], g_fPreStrafe[client], g_fMaxSpeed2[client], g_Strafes[client],g_sync[client],g_flastHeight[client], szSteamId);
			SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery,DBPrio_Low);
		}	
		else
		{
			Format(szQuery, 512, sql_insertPlayerJumpWJ, szSteamId, szName, g_fPersonalWjRecord[client], g_fPreStrafe[client], g_fMaxSpeed2[client], g_Strafes[client],g_sync[client],g_flastHeight[client]);
			SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery,DBPrio_Low);
		}
	}
	db_viewWjRecord2(client);
}

public SQL_UpdateDropBhopRecordCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	new client = data;
	if (IsClientInGame(client))
	{
		decl String:szQuery[512];
		decl String:szUName[MAX_NAME_LENGTH];
		GetClientName(client, szUName, MAX_NAME_LENGTH);
		decl String:szName[MAX_NAME_LENGTH*2+1];
		decl String:szSteamId[32];
		GetClientAuthString(client, szSteamId, 32);
		SQL_QuoteString(g_hDb, szUName, szName, MAX_NAME_LENGTH*2+1);
		if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
		{
			Format(szQuery, 512, sql_updateDropBhop, szName, g_fPersonalDropBhopRecord[client], g_fPreStrafe[client], g_fMaxSpeed2[client], g_Strafes[client],g_sync[client],g_flastHeight[client], szSteamId);
			SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery,DBPrio_Low);
		}
		else
		{
			Format(szQuery, 512, sql_insertPlayerJumpDropBhop, szSteamId, szName, g_fPersonalDropBhopRecord[client], g_fPreStrafe[client], g_fMaxSpeed2[client], g_Strafes[client],g_sync[client],g_flastHeight[client]);
			SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery,DBPrio_Low);
		}
	}
	db_viewDropBhopRecord2(client);
}

public SQL_UpdateBhopRecordCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	new client = data;
	if (IsClientInGame(client))
	{
		decl String:szQuery[512];
		decl String:szUName[MAX_NAME_LENGTH];
		GetClientName(client, szUName, MAX_NAME_LENGTH);
		decl String:szName[MAX_NAME_LENGTH*2+1];
		decl String:szSteamId[32];
		GetClientAuthString(client, szSteamId, 32);
		SQL_QuoteString(g_hDb, szUName, szName, MAX_NAME_LENGTH*2+1);
		if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
		{
			Format(szQuery, 512, sql_updateBhop, szName, g_fPersonalBhopRecord[client], g_fPreStrafe[client], g_fMaxSpeed2[client], g_Strafes[client],g_sync[client],g_flastHeight[client], szSteamId);
			SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery,DBPrio_Low);
		}
		else
		{
			Format(szQuery, 512, sql_insertPlayerJumpBhop, szSteamId, szName, g_fPersonalBhopRecord[client], g_fPreStrafe[client], g_fMaxSpeed2[client], g_Strafes[client],g_sync[client],g_flastHeight[client]);
			SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery,DBPrio_Low);
		}
		db_viewBhopRecord2(client);
	}
}

public SQL_UpdateMultiBhopRecordCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	new client = data;
	if (IsClientInGame(client))
	{
		decl String:szQuery[512];
		decl String:szUName[MAX_NAME_LENGTH];
		GetClientName(client, szUName, MAX_NAME_LENGTH);
		decl String:szName[MAX_NAME_LENGTH*2+1];
		decl String:szSteamId[32];
		if (IsClientInGame(client))
			GetClientAuthString(client, szSteamId, 32);
		else
			return;
		SQL_QuoteString(g_hDb, szUName, szName, MAX_NAME_LENGTH*2+1);
		if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
		{		
			Format(szQuery, 512, sql_updateMultiBhop, szName, g_fPersonalMultiBhopRecord[client], g_fPreStrafe[client], g_fMaxSpeed2[client], g_Strafes[client],g_multi_bhop_count[client],g_sync[client],g_flastHeight[client], szSteamId);
			SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery,DBPrio_Low);
		}
		else
		{		
			Format(szQuery, 512, sql_insertPlayerJumpMultiBhop, szSteamId, szName, g_fPersonalMultiBhopRecord[client], g_fPreStrafe[client], g_fMaxSpeed2[client], g_Strafes[client],g_multi_bhop_count[client],g_sync[client],g_flastHeight[client]);
			SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery,DBPrio_Low);
		}
		db_viewMultiBhopRecord2(client);
	}
}

public SQL_UpdateRecordCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	new client = data;
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		new Float:time;
		time = SQL_FetchFloat(hndl, 3);
		if((g_fFinalTime[client] <= time || time <= 0.0) && g_OverallTp[client] > 0)
		db_updateRecordCP(client);
		else
			if((g_fFinalTime[client] <= time || time <= 0.0) && g_OverallTp[client] == 0)
		db_updateRecordPro(client);
	}    
	else
	{
		if (g_OverallTp[client] > 0)
			db_updateRecordCP(client);	
		else 
			db_updateRecordPro(client);	
	}
}

public db_updateRecordCP(client)
{	
	decl String:szQuery[255];
	decl String:szUName[MAX_NAME_LENGTH];
	decl String:szSteamId[32];
	if (IsClientConnected(client))
	{
		GetClientAuthString(client, szSteamId, 32);
		GetClientName(client, szUName, MAX_NAME_LENGTH);
	}
	else
		return;	
	decl String:szName[MAX_NAME_LENGTH*2+1];
	SQL_QuoteString(g_hDb, szUName, szName, MAX_NAME_LENGTH*2+1);   
	Format(szQuery, 255, sql_updateRecord, szUName, g_OverallTp[client], g_fFinalTime[client], szSteamId, g_szMapName);
	SQL_TQuery(g_hDb, SQL_UpdateRecordTpCallback, szQuery,client,DBPrio_Low);
	g_fPersonalRecord[client] = g_fFinalTime[client];	
}

public db_updateRecordPro(client)
{
	decl String:szQuery[255];
	decl String:szUName[MAX_NAME_LENGTH];
	decl String:szSteamId[32];	
	if (IsClientConnected(client))
	{
		GetClientName(client, szUName, MAX_NAME_LENGTH);
		GetClientAuthString(client, szSteamId, 32);
	}
	else
		return;   
	decl String:szName[MAX_NAME_LENGTH*2+1];
	SQL_QuoteString(g_hDb, szUName, szName, MAX_NAME_LENGTH*2+1);
	Format(szQuery, 255, sql_updateRecordPro, szUName, g_fFinalTime[client], szSteamId, g_szMapName);
	SQL_TQuery(g_hDb, SQL_UpdateRecordProCallback, szQuery,client,DBPrio_Low);
	g_fPersonalRecordPro[client] = g_fFinalTime[client];
}

public SQL_UpdateRecordTpCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	new client = data;
	g_bMapRankToChat[client]=true;
	db_viewMapRankTp(client);
}

public SQL_UpdateRecordProCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	new client = data;
	g_bMapRankToChat[client]=true;
	db_viewMapRankPro(client);
}

public db_selectTPClimbers(client)
{
	decl String:szQuery[255];       
	Format(szQuery, 255, sql_selectTPClimbers, g_szMapName);   
	SQL_TQuery(g_hDb, sql_selectTPClimbersCallback, szQuery, client);
}

public db_selectTopClimbers(client)
{
	decl String:szQuery[1024];       
	Format(szQuery, 1024, sql_selectTopClimbers, g_szMapName, g_szMapName);   
	SQL_TQuery(g_hDb, sql_selectTopClimbersCallback, szQuery, client);
}

public db_selectProClimbers(client)
{
	decl String:szQuery[255];       
	Format(szQuery, 255, sql_selectProClimbers, g_szMapName);   		
	SQL_TQuery(g_hDb, sql_selectProClimbersCallback, szQuery, client);
}
public db_selectTopLj(client)
{
	decl String:szQuery[255];       
	Format(szQuery, 255, sql_selectPlayerJumpTopLJ);   		
	SQL_TQuery(g_hDb, sql_selectPlayerJumpTopLJCallback, szQuery, client);
}

public db_selectTopWj(client)
{
	decl String:szQuery[255];       
	Format(szQuery, 255, sql_selectPlayerJumpTopWJ);   		
	SQL_TQuery(g_hDb, sql_selectPlayerJumpTopWJCallback, szQuery, client);
}

public db_selectTopBhop(client)
{
	decl String:szQuery[255];       
	Format(szQuery, 255, sql_selectPlayerJumpTopBhop);   		
	SQL_TQuery(g_hDb, sql_selectPlayerJumpTopBhopCallback, szQuery, client);
}

public db_selectTopDropBhop(client)
{
	decl String:szQuery[255];       
	Format(szQuery, 255, sql_selectPlayerJumpTopDropBhop);   		
	SQL_TQuery(g_hDb, sql_selectPlayerJumpTopDropBhopCallback, szQuery, client);
}


public db_selectTopMultiBhop(client)
{
	decl String:szQuery[255];       
	Format(szQuery, 255, sql_selectPlayerJumpTopMultiBhop);   		
	SQL_TQuery(g_hDb, sql_selectPlayerJumpTopMultiBhopCallback, szQuery, client);
}

public db_selectMapButtons()
{
	decl String:szQuery[255];       
	Format(szQuery, 255, sql_selectMapButtons, g_szMapName);
	SQL_TQuery(g_hDb, sql_ViewMapButtonsCallback, szQuery);
}

public sql_ViewMapButtonsCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{       
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		new Float:StartCords[3];
		new Float:CordsSprite[3];
		new Float:EndCords[3];
		new Float:Angs[3];
		new Float: angstart;
		new Float: angend;
		Angs[0]=0.0;
		Angs[2]=0.0;
		StartCords[0] = SQL_FetchFloat(hndl, 0);
		StartCords[1] = SQL_FetchFloat(hndl, 1);
		StartCords[2] = SQL_FetchFloat(hndl, 2);
		EndCords[0] = SQL_FetchFloat(hndl, 3);
		EndCords[1] = SQL_FetchFloat(hndl, 4);
		EndCords[2] = SQL_FetchFloat(hndl, 5);	
		angstart = SQL_FetchFloat(hndl, 6);	
		angend = SQL_FetchFloat(hndl, 7);

		new Float:angstartbutton = angstart+180.0;
		new Float:angendbutton = angend+180.0;
		
		//STARTBUTTON
		if (StartCords[0] != -1.0 && StartCords[1] != -1.0 && StartCords[2] != -1.0)
		{
			new ent = CreateEntityByName("prop_physics_override");
			if (ent != -1)
			{  
				Angs[1]=angstartbutton;
				DispatchKeyValue(ent, "model", "models/props/switch001.mdl");
				DispatchKeyValue(ent, "spawnflags", "264");
				DispatchKeyValue(ent, "targetname","climb_startbutton");
				DispatchSpawn(ent);   
				TeleportEntity(ent, StartCords, Angs, NULL_VECTOR);
				g_bMapButtons=true;
				SDKHook(ent, SDKHook_UsePost, OnUsePost);		
			}
			if (angstart != -1.0)
			{
				Angs[1]=angstart;
				new spritestart = CreateEntityByName("env_sprite"); 
				if(spritestart != -1) 
				{ 
					DispatchKeyValue(spritestart, "classname", "env_sprite");
					DispatchKeyValue(spritestart, "spawnflags", "1");
					DispatchKeyValue(spritestart, "scale", "0.2");
					DispatchKeyValue(spritestart, "model", "materials/models/props/startkztimer.vmt"); 
					DispatchKeyValue(spritestart, "targetname", "starttimersign");
					DispatchKeyValue(spritestart, "rendermode", "1");
					DispatchKeyValue(spritestart, "framerate", "0");
					DispatchKeyValue(spritestart, "HDRColorScale", "1.0");
					DispatchKeyValue(spritestart, "rendercolor", "255 255 255");
					DispatchKeyValue(spritestart, "renderamt", "255");
					DispatchSpawn(spritestart);
					CordsSprite = StartCords;
					CordsSprite[2]+=95;
					TeleportEntity(spritestart, CordsSprite, Angs, NULL_VECTOR);
				}	
			}		
		}
		//ENDBUTTON
		if (EndCords[0] != -1.0 && EndCords[1] != -1.0 && EndCords[2] != -1.0)
		{		
			new ent2 = CreateEntityByName("prop_physics_override");
			if (ent2 != -1)
			{  
				Angs[1]=angendbutton;
				DispatchKeyValue(ent2, "model", "models/props/switch001.mdl");
				DispatchKeyValue(ent2, "spawnflags", "264");
				DispatchKeyValue(ent2, "targetname","climb_endbutton");
				DispatchSpawn(ent2);   
				TeleportEntity(ent2, EndCords, Angs, NULL_VECTOR);
				g_bMapButtons=true;
				SDKHook(ent2, SDKHook_UsePost, OnUsePost);		
			}
			if (angend != -1.0)
			{
				Angs[1]=angend;
				new spritestop = CreateEntityByName("env_sprite");
				if(spritestop != -1) 
				{ 
					DispatchKeyValue(spritestop, "classname", "env_sprite");
					DispatchKeyValue(spritestop, "spawnflags", "1");
					DispatchKeyValue(spritestop, "scale", "0.2");
					DispatchKeyValue(spritestop, "model", "materials/models/props/stopkztimer.vmt"); 
					DispatchKeyValue(spritestop, "targetname", "stoptimersign");
					DispatchKeyValue(spritestop, "rendermode", "1");
					DispatchKeyValue(spritestop, "framerate", "0");
					DispatchKeyValue(spritestop, "HDRColorScale", "1.0");
					DispatchKeyValue(spritestop, "rendercolor", "255 255 255");
					DispatchKeyValue(spritestop, "renderamt", "255");	
					DispatchSpawn(spritestop);
					CordsSprite = EndCords;
					CordsSprite[2]+=95;
					TeleportEntity(spritestop, CordsSprite, Angs, NULL_VECTOR);
				}	
			}	
		}
		
		
	}
}

public sql_selectPlayerJumpTopLJCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{       
	new client = data;
	decl String:szValue[128];
	decl String:szName[64];
	decl String:szSteamID[32];
	new Float:ljrecord;
	new String:szStrafes[32];
	new strafes;
	new Handle:menu = CreateMenu(LjJumpMenuHandler1);
	SetMenuTitle(menu, "Top 20 Longjump\n    Rank    Distance           Strafes      Player");  
	SetMenuPagination(menu, 5);
	if(SQL_HasResultSet(hndl))
	{
		new i = 1;
		while (SQL_FetchRow(hndl))
		{
			SQL_FetchString(hndl, 0, szName, 64);
			ljrecord = SQL_FetchFloat(hndl, 1); 
			strafes = SQL_FetchInt(hndl, 2); 
			SQL_FetchString(hndl, 3, szSteamID, 32);
			if (strafes < 10)
				Format(szStrafes, 32, " %i ", strafes); 
			else
				Format(szStrafes, 32, "%i", strafes); 
			if (i < 10)
					Format(szValue, 128, "[0%i.]    %.3f units      %s      » %s", i, ljrecord,szStrafes, szName);
				else
					Format(szValue, 128, "[%i.]    %.3f units      %s      » %s", i, ljrecord,szStrafes, szName);
			AddMenuItem(menu, szSteamID, szValue, ITEMDRAW_DEFAULT);
			i++;
		}
	}
	SetMenuOptionFlags(menu, MENUFLAG_BUTTON_EXIT);
	DisplayMenu(menu, client, MENU_TIME_FOREVER);
}

public sql_selectPlayerJumpTopWJCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{       
	new client = data;
	decl String:szValue[128];
	decl String:szName[64];
	new Float:ljrecord;
	new String:szStrafes[32];
	decl String:szSteamID[32];
	new strafes;
	new Handle:menu = CreateMenu(WjJumpMenuHandler1);
	SetMenuTitle(menu, "Top 20 Weirdjump\n    Rank    Distance           Strafes      Player");  
	SetMenuPagination(menu, 5);
	if(SQL_HasResultSet(hndl))
	{
		new i = 1;
		while (SQL_FetchRow(hndl))
		{
			SQL_FetchString(hndl, 0, szName, 64);
			ljrecord = SQL_FetchFloat(hndl, 1); 
			strafes = SQL_FetchInt(hndl, 2); 
			SQL_FetchString(hndl, 3, szSteamID, 32);
			if (strafes < 10)
				Format(szStrafes, 32, " %i ", strafes); 
			else
				Format(szStrafes, 32, "%i", strafes); 
			if (i < 10)
					Format(szValue, 128, "[0%i.]    %.3f units      %s      » %s", i, ljrecord,szStrafes, szName);
				else
					Format(szValue, 128, "[%i.]    %.3f units      %s      » %s", i, ljrecord,szStrafes, szName);
			AddMenuItem(menu, szSteamID, szValue, ITEMDRAW_DEFAULT);
			i++;
		}
	}
	SetMenuOptionFlags(menu, MENUFLAG_BUTTON_EXIT);
	DisplayMenu(menu, client, MENU_TIME_FOREVER);
}

public sql_selectPlayerJumpTopBhopCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{       
	new client = data;
	decl String:szValue[128];
	decl String:szName[64];
	new Float:bhoprecord;
	decl String:szSteamID[32];
	new String:szStrafes[32];
	new strafes;
	new Handle:menu = CreateMenu(BhopJumpMenuHandler1);
	SetMenuTitle(menu, "Top 20 Bunnyhop\n    Rank    Distance           Strafes      Player");  
	SetMenuPagination(menu, 5);
	if(SQL_HasResultSet(hndl))
	{
		new i = 1;
		while (SQL_FetchRow(hndl))
		{
			SQL_FetchString(hndl, 0, szName, 64);
			bhoprecord = SQL_FetchFloat(hndl, 1); 
			strafes = SQL_FetchInt(hndl, 2); 
			SQL_FetchString(hndl, 3, szSteamID, 32);
			if (strafes < 10)
				Format(szStrafes, 32, " %i ", strafes); 
			else
				Format(szStrafes, 32, "%i", strafes); 
			if (i < 10)
					Format(szValue, 128, "[0%i.]    %.3f units      %s      » %s", i, bhoprecord,szStrafes, szName);
				else
					Format(szValue, 128, "[%i.]    %.3f units      %s      » %s", i, bhoprecord,szStrafes, szName);
			AddMenuItem(menu, szSteamID, szValue, ITEMDRAW_DEFAULT);
			i++;
		}
	}
	SetMenuOptionFlags(menu, MENUFLAG_BUTTON_EXIT);
	DisplayMenu(menu, client, MENU_TIME_FOREVER);
}

public sql_selectPlayerJumpTopDropBhopCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{       
	new client = data;
	decl String:szValue[128];
	decl String:szName[64];
	new Float:bhoprecord;
	decl String:szSteamID[32];
	new String:szStrafes[32];
	new strafes;
	new Handle:menu = CreateMenu(DropBhopJumpMenuHandler1);
	SetMenuTitle(menu, "Top 20 Drop-Bunnyhop\n    Rank    Distance           Strafes      Player");  
	SetMenuPagination(menu, 5);
	if(SQL_HasResultSet(hndl))
	{
		new i = 1;
		while (SQL_FetchRow(hndl))
		{
			SQL_FetchString(hndl, 0, szName, 64);
			bhoprecord = SQL_FetchFloat(hndl, 1); 
			strafes = SQL_FetchInt(hndl, 2); 
			SQL_FetchString(hndl, 3, szSteamID, 32);
			if (strafes < 10)
				Format(szStrafes, 32, " %i ", strafes); 
			else
				Format(szStrafes, 32, "%i", strafes); 
			if (i < 10)
					Format(szValue, 128, "[0%i.]    %.3f units      %s      » %s", i, bhoprecord,szStrafes, szName);
				else
					Format(szValue, 128, "[%i.]    %.3f units      %s      » %s", i, bhoprecord,szStrafes, szName);
			AddMenuItem(menu, szSteamID, szValue, ITEMDRAW_DEFAULT);
			i++;
		}
	}
	SetMenuOptionFlags(menu, MENUFLAG_BUTTON_EXIT);
	DisplayMenu(menu, client, MENU_TIME_FOREVER);
}

public sql_selectPlayerJumpTopMultiBhopCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{       
	new client = data;
	decl String:szValue[128];
	decl String:szName[64];
	new Float:multibhoprecord;
	decl String:szSteamID[32];
	new String:szStrafes[32];
	new strafes;
	new Handle:menu = CreateMenu(MultiBhopJumpMenuHandler1);
	SetMenuTitle(menu, "Top 20 Multi-Bunnyhop\n    Rank    Distance           Strafes      Player");  
	SetMenuPagination(menu, 5);
	if(SQL_HasResultSet(hndl))
	{
		new i = 1;
		while (SQL_FetchRow(hndl))
		{
			SQL_FetchString(hndl, 0, szName, 64);
			multibhoprecord = SQL_FetchFloat(hndl, 1); 
			strafes = SQL_FetchInt(hndl, 2); 
			SQL_FetchString(hndl, 3, szSteamID, 32);
			if (strafes < 10)
				Format(szStrafes, 32, " %i ", strafes); 
			else
				Format(szStrafes, 32, "%i", strafes); 	
			if (i < 10)
					Format(szValue, 128, "[0%i.]    %.3f units      %s      » %s", i, multibhoprecord,szStrafes, szName);
				else
					Format(szValue, 128, "[%i.]    %.3f units      %s      » %s", i, multibhoprecord,szStrafes, szName);
			AddMenuItem(menu, szSteamID, szValue, ITEMDRAW_DEFAULT);
			i++;
		}
	}
	SetMenuOptionFlags(menu, MENUFLAG_BUTTON_EXIT);
	DisplayMenu(menu, client, MENU_TIME_FOREVER);
}

public sql_selectTopClimbersCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{       
	new client = data;
	decl String:szValue[128];
	decl String:szName[64];
	new Float:time;
	new teleports;
	decl String:szTeleports[32];
	decl String:szSteamID[32];
	new String:lineBuf[256];
	new Handle:stringArray = CreateArray(100);
	new Handle:menu = CreateMenu(MapMenuHandler1);
	SetMenuPagination(menu, 5);
	new bool:bduplicat = false;
	SetMenuTitle(menu, "Top 50 Climbers (local)\n    Rank    Time          TP's        Player");     
	if(SQL_HasResultSet(hndl))
	{
		new i = 1;
		while (SQL_FetchRow(hndl))
		{
			bduplicat = false;
			SQL_FetchString(hndl, 0, szSteamID, 32);
			SQL_FetchString(hndl, 1, szName, 64);
			time = SQL_FetchFloat(hndl, 2); 
			teleports = SQL_FetchInt(hndl, 3);		
			new stringArraySize = GetArraySize(stringArray);
			for(new x = 0; x < stringArraySize; x++)
			{
				GetArrayString(stringArray, x, lineBuf, sizeof(lineBuf));
				if (StrEqual(lineBuf, szName, false))
					bduplicat=true;		
			}
			if (bduplicat==false && i < 51)
			{
				if (teleports < 10)
					Format(szTeleports, 32, "    %i",teleports);
				else
				if (teleports < 100)
					Format(szTeleports, 32, "  %i",teleports);
				else
					Format(szTeleports, 32, "%i",teleports);
				
				FormatTimeFloat(client, time, 3);
				if (time<3600.0)
					Format(g_szTime[client], 32, "   %s", g_szTime[client]);			
				if (i == 100)
					Format(szValue, 128, "[%i.] %s | %s    » %s", i, g_szTime[client], szTeleports, szName);
				if (i >= 10)
					Format(szValue, 128, "[%i.] %s | %s    » %s", i, g_szTime[client], szTeleports, szName);
				else
					Format(szValue, 128, "[0%i.] %s | %s    » %s", i, g_szTime[client], szTeleports, szName);
				AddMenuItem(menu, szSteamID, szValue, ITEMDRAW_DEFAULT);
				PushArrayString(stringArray, szName);
				i++;
			}
		}
		if(i == 1)
		{
			PrintToChat(client, "%t", "NoTopRecords", MOSSGREEN,WHITE, g_szMapName);
		}
	}
	SetMenuOptionFlags(menu, MENUFLAG_BUTTON_EXIT);
	DisplayMenu(menu, client, MENU_TIME_FOREVER);
	CloseHandle(stringArray);
}
public sql_selectTPClimbersCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{       
	new client = data;
	decl String:szValue[128];
	decl String:szName[64];
	new Float:time;
	new teleports;
	decl String:szTeleports[32];
	decl String:szSteamID[32];
	new Handle:menu = CreateMenu(MapMenuHandler2);
	SetMenuPagination(menu, 5);
	SetMenuTitle(menu, "Top 20 TP Climbers (local)\n    Rank    Time          TP's          Player");     
	if(SQL_HasResultSet(hndl))
	{
		new i = 1;
		while (SQL_FetchRow(hndl))
		{
			SQL_FetchString(hndl, 0, szName, 64);
			time = SQL_FetchFloat(hndl, 1); 
			teleports = SQL_FetchInt(hndl, 2);		
			SQL_FetchString(hndl, 3, szSteamID, 32);
			if (teleports < 10)
				Format(szTeleports, 32, "    %i",teleports);
			else
				if (teleports < 100)
					Format(szTeleports, 32, "  %i",teleports);
				else
					Format(szTeleports, 32, "%i",teleports);
			
			FormatTimeFloat(client, time, 3);
			if (time<3600.0)
				Format(g_szTime[client], 32, "   %s", g_szTime[client]);			
			if (i < 10)
				Format(szValue, 128, "[0%i.] %s | %s      » %s", i, g_szTime[client], szTeleports, szName);
			else
				Format(szValue, 128, "[%i.] %s | %s      » %s", i, g_szTime[client], szTeleports, szName);
			AddMenuItem(menu, szSteamID, szValue, ITEMDRAW_DEFAULT);
			i++;
		}
		if(i == 1)
		{
			PrintToChat(client, "%t", "NoTpRecords", MOSSGREEN,WHITE, g_szMapName);
		}
	}
	SetMenuOptionFlags(menu, MENUFLAG_BUTTON_EXIT);
	DisplayMenu(menu, client, MENU_TIME_FOREVER);
}
public sql_selectProClimbersCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{      
	new client = data;
	decl String:szValue[128];
	decl String:szSteamID[32];
	decl String:szName[64];
	new Float:time;
	new Handle:menu = CreateMenu(MapMenuHandler3);
	SetMenuPagination(menu, 5);
	SetMenuTitle(menu, "Top 20 PRO Climbers (local)\n    Rank   Time               Player");     
	if(SQL_HasResultSet(hndl))
		
	{
		new i = 1;
		while (SQL_FetchRow(hndl))
		{		
			SQL_FetchString(hndl, 0, szName, 64);
			time = SQL_FetchFloat(hndl, 1);		
			SQL_FetchString(hndl, 2, szSteamID, 32);
			FormatTimeFloat(client, time, 3);			
			if (time<3600.0)
				Format(g_szTime[client], 32, "  %s", g_szTime[client]);
			if (i < 10)
				Format(szValue, 128, "[0%i.] %s    » %s", i, g_szTime[client], szName);
			else
				Format(szValue, 128, "[%i.] %s    » %s", i, g_szTime[client], szName);
			AddMenuItem(menu, szSteamID, szValue, ITEMDRAW_DEFAULT);
			i++;
		}
		if(i == 1)
		{
			PrintToChat(client, "%t", "NoProRecords",MOSSGREEN,WHITE, g_szMapName);
		}
	}     
	SetMenuOptionFlags(menu, MENUFLAG_BUTTON_EXIT);
	DisplayMenu(menu, client, MENU_TIME_FOREVER);
}
public TopChallengeHandler1(Handle:menu, MenuAction:action, param1, param2)
{

	if (action ==  MenuAction_Select)
	{
		decl String:info[32];
		GetMenuItem(menu, param2, info, sizeof(info));
		detailView[param1]=3;
		db_viewPlayerRank(param1,info);
	}

	if (action ==  MenuAction_Cancel)
	{
		TopMenu(param1);
	}
	else if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}

public TopTpHoldersHandler1(Handle:menu, MenuAction:action, param1, param2)
{

	if (action ==  MenuAction_Select)
	{
		decl String:info[32];
		GetMenuItem(menu, param2, info, sizeof(info));
		detailView[param1]=10;
		db_viewPlayerRank(param1,info);
	}

	if (action ==  MenuAction_Cancel)
	{
		TopMenu(param1);
	}
	else if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}
public TopProHoldersHandler1(Handle:menu, MenuAction:action, param1, param2)
{

	if (action ==  MenuAction_Select)
	{
		decl String:info[32];
		GetMenuItem(menu, param2, info, sizeof(info));
		detailView[param1]=11;
		db_viewPlayerRank(param1,info);
	}

	if (action ==  MenuAction_Cancel)
	{
		TopMenu(param1);
	}
	else if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}

public TopPlayersMenuHandler1(Handle:menu, MenuAction:action, param1, param2)
{
	if (action ==  MenuAction_Select)
	{
		decl String:info[32];
		GetMenuItem(menu, param2, info, sizeof(info));
		detailView[param1]=0;
		db_viewPlayerRank(param1,info);
	}
	if (action ==  MenuAction_Cancel)
	{
		TopMenu(param1);
	}
	else if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}

public LjJumpMenuHandler1(Handle:menu, MenuAction:action, param1, param2)
{
	if (action ==  MenuAction_Select)
	{
		decl String:info[32];
		GetMenuItem(menu, param2, info, sizeof(info));
		detailView[param1] = 2;
		db_viewPlayerRank(param1, info);	
	}
	if (action ==  MenuAction_Cancel)
	{
		JumpTopMenu(param1);
	}
	else if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}
public WjJumpMenuHandler1(Handle:menu, MenuAction:action, param1, param2)
{
	if (action ==  MenuAction_Select)
	{
		decl String:info[32];
		GetMenuItem(menu, param2, info, sizeof(info));
		detailView[param1] = 4;
		db_viewPlayerRank(param1, info);	
	}
	if (action ==  MenuAction_Cancel)
	{
		JumpTopMenu(param1);
	}
	else if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}
public BhopJumpMenuHandler1(Handle:menu, MenuAction:action, param1, param2)
{
	if (action ==  MenuAction_Select)
	{
		decl String:info[32];
		GetMenuItem(menu, param2, info, sizeof(info));
		detailView[param1] = 5;
		db_viewPlayerRank(param1, info);	
	}
	if (action ==  MenuAction_Cancel)
	{
		JumpTopMenu(param1);
	}
	else if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}
public DropBhopJumpMenuHandler1(Handle:menu, MenuAction:action, param1, param2)
{
	if (action ==  MenuAction_Select)
	{
		decl String:info[32];
		GetMenuItem(menu, param2, info, sizeof(info));
		detailView[param1] = 6;
		db_viewPlayerRank(param1, info);	
	}
	if (action ==  MenuAction_Cancel)
	{
		JumpTopMenu(param1);
	}
	else if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}

public MultiBhopJumpMenuHandler1(Handle:menu, MenuAction:action, param1, param2)
{
	if (action ==  MenuAction_Select)
	{
		decl String:info[32];
		GetMenuItem(menu, param2, info, sizeof(info));
		detailView[param1] = 7;
		db_viewPlayerRank(param1, info);	
	}
	if (action ==  MenuAction_Cancel)
	{
		JumpTopMenu(param1);
	}
	else if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}

public MapMenuHandler1(Handle:menu, MenuAction:action, param1, param2)
{
	if (action ==  MenuAction_Select)
	{
		decl String:info[32];
		GetMenuItem(menu, param2, info, sizeof(info));
		detailView[param1] = 1;
		db_viewPlayerRank(param1, info);		
	}
	if (action ==  MenuAction_Cancel)
	{
		MapTopMenu(param1);
	}
	else if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}

public MapMenuHandler2(Handle:menu, MenuAction:action, param1, param2)
{
	if (action ==  MenuAction_Select)
	{
		decl String:info[32];
		GetMenuItem(menu, param2, info, sizeof(info));
		detailView[param1] = 8;
		db_viewPlayerRank(param1, info);		
	}
	if (action ==  MenuAction_Cancel)
	{
		MapTopMenu(param1);
	}
	else if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}


public MapMenuHandler3(Handle:menu, MenuAction:action, param1, param2)
{
	if (action ==  MenuAction_Select)
	{
		decl String:info[32];
		GetMenuItem(menu, param2, info, sizeof(info));
		detailView[param1] = 9;
		db_viewPlayerRank(param1, info);		
	}
	if (action ==  MenuAction_Cancel)
	{
		MapTopMenu(param1);
	}
	else if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}


public GlobalMapMenuHandler(Handle:menu, MenuAction:action, param1, param2)
{
	if (action ==  MenuAction_Cancel || action ==  MenuAction_Select)
	{
		MapTopMenu(param1);
	}
	else if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}

public MenuHandler2(Handle:menu, MenuAction:action, param1, param2)
{
	if (action ==  MenuAction_Cancel || action ==  MenuAction_Select)
	{
		ProfileMenu(param1, -1);
	}
	else if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}

public SQL_SelectPlayerCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{       
	new client = data;
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl) && IsClientInGame(client))
	{
	}
	else
		db_insertPlayer(client);
}


public db_GetMapRecord_CP()
{
	decl String:szQuery[255];      
	Format(szQuery, 255, sql_selectMapRecordCP, g_szMapName);       
	SQL_TQuery(g_hDb, sql_selectMapRecordCPCallback, szQuery);
}
public db_GetMapRecord_Pro()
{
	decl String:szQuery[255];      
	Format(szQuery, 255, sql_selectMapRecordPro, g_szMapName);      
	SQL_TQuery(g_hDb, sql_selectMapRecordProCallback, szQuery);
}
public sql_selectMapRecordCPCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{

	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
	
		if (SQL_FetchFloat(hndl, 0) > -1.0)
		{
			g_fRecordTime = SQL_FetchFloat(hndl, 0);
			SQL_FetchString(hndl, 1, g_szRecordPlayer, MAX_NAME_LENGTH);	
		}
		else
			g_fRecordTime = 9999999.0;	
	}
	else
		g_fRecordTime = 9999999.0;		   
}

public sql_selectMapRecordProCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		if (SQL_FetchFloat(hndl, 0) > -1.0)
		{
			g_fRecordTimePro = SQL_FetchFloat(hndl, 0);
			SQL_FetchString(hndl, 1, g_szRecordPlayerPro, MAX_NAME_LENGTH);	
		}
		else
			g_fRecordTimePro = 9999999.0;
	}
	else
		g_fRecordTimePro = 9999999.0;
}

public db_dropMap(client)
{
	SQL_LockDatabase(g_hDb);       
	if(g_DbType == MYSQL)
		SQL_FastQuery(g_hDb, sql_dropMap);
	else
		SQL_FastQuery(g_hDb, sqlite_dropMap);	
	SQL_UnlockDatabase(g_hDb);       
	PrintToConsole(client, "map buttons table dropped. Please restart your server!");
}

public db_dropPlayer(client)
{
	SQL_LockDatabase(g_hDb);
	if(g_DbType == MYSQL)
		SQL_FastQuery(g_hDb, sql_dropPlayer);
	else
		SQL_FastQuery(g_hDb, sqlite_dropPlayer);
	SQL_UnlockDatabase(g_hDb);
	PrintToConsole(client, "playertimes table dropped. Please restart your server!");
}

public db_dropPlayerRanks(client)
{
	SQL_LockDatabase(g_hDb);
	if(g_DbType == MYSQL)
		SQL_FastQuery(g_hDb, sql_dropPlayerRank);
	else
		SQL_FastQuery(g_hDb, sqlite_dropPlayerRank);
	SQL_UnlockDatabase(g_hDb);
	PrintToConsole(client, "playerranks table dropped. Please restart your server!");
}

public db_dropPlayerJump(client)
{
	SQL_LockDatabase(g_hDb);
	if(g_DbType == MYSQL)
		SQL_FastQuery(g_hDb, sql_dropPlayerJump);
	else
		SQL_FastQuery(g_hDb, sqlite_dropPlayerJump);
	SQL_UnlockDatabase(g_hDb);
	PrintToConsole(client, "jumpstats table dropped. Please restart your server!");
}

public db_resetMapRecords(client, String:szMapName[128])
{
	decl String:szQuery[255];      
	Format(szQuery, 255, sql_resetMapRecords, szMapName);
	SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery);	       
	PrintToConsole(client, "player times on %s cleared.", szMapName);
	if (StrEqual(szMapName,g_szMapName))
	{
		for (new i = 1; i <= MaxClients; i++)
		{
			if (1 <= i <= MaxClients && IsClientInGame(i))
			{
				g_fPersonalRecord[i] = 0.0;
				g_fPersonalRecordPro[i] = 0.0;
				g_maprank_tp[i] = 99999;
				g_maprank_pro[i] = 99999;
			}
		}
	}            
	db_GetMapRecord_CP();
	db_GetMapRecord_Pro();
}

public db_resetPlayerRecords(client, String:steamid[128])
{
	decl String:szQuery[255];    
	decl String:szsteamid[128*2+1];
	SQL_QuoteString(g_hDb, steamid, szsteamid, 128*2+1);   	
	Format(szQuery, 255, sql_resetRecords, szsteamid);       
	SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery);	        
	PrintToConsole(client, "map times of %s cleared.", szsteamid);
 
	for (new i = 1; i <= MaxClients; i++)
	{
		if (1 <= i <= MaxClients && IsClientInGame(i))
		{
			decl String:szSteamId2[32];
			GetClientAuthString(i, szSteamId2, 32);
			if(StrEqual(szSteamId2,szsteamid))
			{
				g_fPersonalRecord[i] = 0.0;
				g_fPersonalRecordPro[i] = 0.0;
				g_maprank_tp[i] = 99999;
				g_maprank_pro[i] = 99999;
			}
		}
	}		
	db_GetMapRecord_CP();
	db_GetMapRecord_Pro();
}

public db_resetPlayerRecords2(client, String:steamid[128], String:szMapName[MAX_MAP_LENGTH])
{
	decl String:szQuery[255];      
	decl String:szsteamid[128*2+1];
	
	SQL_QuoteString(g_hDb, steamid, szsteamid, 128*2+1);      
	Format(szQuery, 255, sql_resetRecords2, szsteamid, szMapName);       
	SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery);	    
	PrintToConsole(client, "map times of %s on %s cleared.", steamid, szMapName);
    
	if (StrEqual(szMapName,g_szMapName))
	{
		for (new i = 1; i <= MaxClients; i++)
		{
			if (1 <= i <= MaxClients && IsClientInGame(i))
			{
				decl String:szSteamId2[32];
				GetClientAuthString(i, szSteamId2, 32);
				if(StrEqual(szSteamId2,szsteamid))
				{
					g_fPersonalRecord[i] = 0.0;
					g_fPersonalRecordPro[i] = 0.0;
					g_maprank_tp[i] = 99999;
					g_maprank_pro[i] = 99999;
				}
			}
		}
	}    
	db_GetMapRecord_CP();
	db_GetMapRecord_Pro();
}

public db_resetPlayerBhopRecord(client, String:steamid[128])
{
	decl String:szQuery[255];
	decl String:szsteamid[128*2+1];
	SQL_QuoteString(g_hDb, steamid, szsteamid, 128*2+1);      
	Format(szQuery, 255, sql_resetBhopRecord, szsteamid);       
	SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery);	      
	PrintToConsole(client, "bhop record cleared (%s).", szsteamid);
	for (new i = 1; i <= MaxClients; i++)
	{
		if (1 <= i <= MaxClients && IsClientInGame(i))
		{
			decl String:szSteamId2[32];
			GetClientAuthString(i, szSteamId2, 32);
			if(StrEqual(szSteamId2,szsteamid))
			{
				g_BhopRank[i] = 99999999;
				g_fPersonalBhopRecord[i] = -1.0;
			}
		}
	}
}

public db_resetPlayerDropBhopRecord(client, String:steamid[128])
{
	decl String:szQuery[255];
	decl String:szsteamid[128*2+1];
	SQL_QuoteString(g_hDb, steamid, szsteamid, 128*2+1);      
	Format(szQuery, 255, sql_resetDropBhopRecord, szsteamid);       
	SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery);	
	PrintToConsole(client, "dropbhop record cleared (%s).", szsteamid);
	for (new i = 1; i <= MaxClients; i++)
	{
		if (1 <= i <= MaxClients && IsClientInGame(i))
		{
			decl String:szSteamId2[32];
			GetClientAuthString(i, szSteamId2, 32);
			if(StrEqual(szSteamId2,szsteamid))
			{
				g_DropBhopRank[i] = 99999999;
				g_fPersonalDropBhopRecord[i] = -1.0;
			}
		}
	}
}

public db_resetPlayerWJRecord(client, String:steamid[128])
{
	decl String:szQuery[255];
	decl String:szsteamid[128*2+1];
	SQL_QuoteString(g_hDb, steamid, szsteamid, 128*2+1);      
	Format(szQuery, 255, sql_resetWJRecord, szsteamid);     
	SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery);	
	PrintToConsole(client, "wj record cleared (%s).", szsteamid);
	for (new i = 1; i <= MaxClients; i++)
	{
		if (1 <= i <= MaxClients && IsClientInGame(i))
		{
			decl String:szSteamId2[32];
			GetClientAuthString(i, szSteamId2, 32);
			if(StrEqual(szSteamId2,szsteamid))
			{
				g_wjRank[i] = 99999999;
				g_fPersonalWjRecord[i] = -1.0;
			}
		}
	}
}

public db_resetPlayerMultiBhopRecord(client, String:steamid[128])
{
	decl String:szQuery[255];
	decl String:szsteamid[128*2+1];
	SQL_QuoteString(g_hDb, steamid, szsteamid, 128*2+1);      
	Format(szQuery, 255, sql_resetMultiBhopRecord, szsteamid);
	SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery);	    
	PrintToConsole(client, "multibhop record cleared (%s).", szsteamid);
	for (new i = 1; i <= MaxClients; i++)
	{
		if (1 <= i <= MaxClients && IsClientInGame(i))
		{
			decl String:szSteamId2[32];
			GetClientAuthString(i, szSteamId2, 32);
			if(StrEqual(szSteamId2,szsteamid))
			{
				g_MultiBhopRank[i] = 99999999;
				g_fPersonalMultiBhopRecord[i] = -1.0;
			}
		}
	}
}

public db_resetPlayerLjRecord(client, String:steamid[128])
{
	decl String:szQuery[255];
	decl String:szsteamid[128*2+1];
	SQL_QuoteString(g_hDb, steamid, szsteamid, 128*2+1);      
	Format(szQuery, 255, sql_resetLjRecord, szsteamid);       
	SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery);	    
	PrintToConsole(client, "lj record cleared (%s).", szsteamid);
	for (new i = 1; i <= MaxClients; i++)
	{
		if (1 <= i <= MaxClients && IsClientInGame(i))
		{
			decl String:szSteamId2[32];
			GetClientAuthString(i, szSteamId2, 32);
			if(StrEqual(szSteamId2,szsteamid))
			{
				g_LjRank[i] = 99999999;
				g_fPersonalLjRecord[i] = -1.0;
			}
		}
	}
}

public SQL_CheckCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
}

public SQL_InsertCheckCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
}

public sql_updateRunTmpCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
}

public sql_deletePlayerCheckCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
}

public RecordPanelHandler(Handle:menu, MenuAction:action, param1, param2)
{
	if(action ==  MenuAction_Select)
	{
		if (g_CMOpen[param1])
		{
			g_CMOpen[param1]=false;
			ClimbersMenu(param1)
		}
		else
			ProfileMenu(param1,-1);
	}	
}

public RecordPanelHandler2(Handle:menu, MenuAction:action, param1, param2)
{
	if (action ==  MenuAction_Select)
	{
		TopMenu(param1);
	}
}




/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
////////////////////////PLAYER-RANKING-SYSTEM////////////////////
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////START/
/////////////////////////////////////////////////////////////////

public RefreshPlayerRankTable()
{
	g_i=1;
	g_pr_refreshingDB=true;
	decl String:szQuery[255];
	Format(szQuery, 255, sql_selectRankedPlayers);      
	SQL_TQuery(g_hDb, sql_selectRankedPlayersCallback, szQuery);
}

public sql_selectRankedPlayersCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(SQL_HasResultSet(hndl))
	{	
		new i = 66;
		g_pr_row = 0;
		g_pr_rowcount = SQL_GetRowCount(hndl);
		while (SQL_FetchRow(hndl))
		{			
			g_pr_row++;
			g_pr_points[i] = 0;
			SQL_FetchString(hndl, 0, g_pr_szSteamID[i], 32);
			SQL_FetchString(hndl, 1, g_pr_szName[i], 64);
			db_viewPersonalBhopRecord(i,g_pr_szSteamID[i]);
			db_viewPersonalMultiBhopRecord(i,g_pr_szSteamID[i]);
			db_viewPersonalWeirdRecord(i,g_pr_szSteamID[i]);
			db_viewPersonalDropBhopRecord(i,g_pr_szSteamID[i]); 
			db_viewPersonalLJRecord(i,g_pr_szSteamID[i]);
			i++;
		}
	}
}

public db_viewPlayerOptions(client, String:szSteamId[32])
{
	decl String:szQuery[512];      
	Format(szQuery, 512, sql_selectPlayerOptions, szSteamId);     
	SQL_TQuery(g_hDb, db_viewPlayerOptionsCallback, szQuery,client);	
}

public db_viewPlayerOptionsCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	new client = data;		
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{		
		g_bColorChat[client]=IntoBool(SQL_FetchInt(hndl, 0));
		g_bInfoPanel[client]=IntoBool(SQL_FetchInt(hndl, 1));
		g_bClimbersMenuSounds[client]=IntoBool(SQL_FetchInt(hndl,2));
		g_bEnableQuakeSounds[client]=IntoBool(SQL_FetchInt(hndl, 3)); 
		g_bAutoBhopClient[client]=IntoBool(SQL_FetchInt(hndl, 4)); //FieldName ShowKeys
		g_bShowNames[client]=IntoBool(SQL_FetchInt(hndl, 5));
		g_bStrafeSync[client]=IntoBool(SQL_FetchInt(hndl, 7));
		g_bGoToClient[client]=IntoBool(SQL_FetchInt(hndl, 6));
		g_bShowTime[client]=IntoBool(SQL_FetchInt(hndl, 8));
		g_bHide[client]=IntoBool(SQL_FetchInt(hndl, 9));
		g_bShowSpecs[client]=IntoBool(SQL_FetchInt(hndl, 10));		
		g_bCPTextMessage[client]=IntoBool(SQL_FetchInt(hndl, 11));
		g_bAdvancedClimbersMenu[client]=IntoBool(SQL_FetchInt(hndl, 12));
		g_bJumpPenalty[client]=IntoBool(SQL_FetchInt(hndl, 14));
		//org
		g_borg_AutoBhopClient[client] = g_bAutoBhopClient[client];
		g_borg_ColorChat[client] = g_bColorChat[client];
		g_borg_InfoPanel[client] = g_bInfoPanel[client];
		g_borg_ClimbersMenuSounds[client] = g_bClimbersMenuSounds[client];
		g_borg_EnableQuakeSounds[client] = g_bEnableQuakeSounds[client];
		g_borg_ShowNames[client] = g_bShowNames[client];
		g_borg_StrafeSync[client] = g_bStrafeSync[client];
		g_borg_GoToClient[client] = g_bGoToClient[client];
		g_borg_ShowTime[client] = g_bShowTime[client]; 
		g_borg_Hide[client] = g_bHide[client];
		g_borg_ShowSpecs[client] = g_bShowSpecs[client]; 
		g_borg_CPTextMessage[client] = g_bCPTextMessage[client];
		g_borg_AdvancedClimbersMenu[client] = g_bAdvancedClimbersMenu[client];
		g_borg_JumpPenalty[client] = g_bJumpPenalty[client];
	}
	else
	{
		decl String:szQuery[512];      
		decl String:szSteamId[32];
		if (IsClientConnected(client))
			GetClientAuthString(client, szSteamId, 32);
		else
			return;
		Format(szQuery, 512, sql_insertPlayerOptions, szSteamId, 1,0,1,1,1,1,1,0,1,0,1,0,0,"weapon_knife",0,0,0,0)
		SQL_TQuery(g_hDb, SQL_InsertCheckCallback, szQuery,DBPrio_Low);			
		g_borg_ColorChat[client] = true;
		g_borg_InfoPanel[client] = false;
		g_borg_ClimbersMenuSounds[client] = true;
		g_borg_EnableQuakeSounds[client] = true;
		g_borg_ShowNames[client] = true
		g_borg_StrafeSync[client] = false;
		g_borg_GoToClient[client] = true;
		g_borg_ShowTime[client] = true; 
		g_borg_Hide[client] = false;
		g_borg_ShowSpecs[client] = true; 
		g_borg_CPTextMessage[client] = false;
		g_borg_AdvancedClimbersMenu[client] = true;
		g_borg_AutoBhopClient[client] = true;
		g_borg_JumpPenalty[client] = false;
	}
}
	
public db_viewPlayerPoints(client)
{
	g_pr_multiplier[client] = 0;
	g_pr_finishedmaps_pro[client] = 0;
	g_pr_finishedmaps_tp[client] = 0;
	g_pr_finishedmaps_pro_perc[client] = 0.0;
	g_pr_finishedmaps_tp_perc[client] = 0.0;
	g_pr_points[client] = 0;
	decl String:szQuery[255];      
	decl String:szSteamId[32];
	if (IsClientConnected(client))
		GetClientAuthString(client, szSteamId, 32);
	else
		return;
	Format(szQuery, 255, sql_selectRankedPlayer, szSteamId);     
	SQL_TQuery(g_hDb, db_viewPlayerPointsCallback, szQuery,client);	
}

public db_viewPlayerPointsCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	new client = data;
		
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{		
		g_pr_points[client]=SQL_FetchInt(hndl, 2);	
		g_pr_finishedmaps_tp[client]=SQL_FetchInt(hndl, 3);	
		g_pr_finishedmaps_pro[client] = SQL_FetchInt(hndl, 4);	
		g_pr_multiplier[client] = SQL_FetchInt(hndl, 5);
		g_challenge_win_ratio[client] = SQL_FetchInt(hndl, 6);
		g_challenge_points_ratio[client] = SQL_FetchInt(hndl, 7);
		g_pr_finishedmaps_tp_perc[client]= (float(g_pr_finishedmaps_tp[client]) / float(g_pr_mapcount)) * 100.0;
		g_pr_finishedmaps_pro_perc[client]= (float(g_pr_finishedmaps_pro[client]) / float(g_pr_mapcount)) * 100.0;	
	}
	else
	{
		if (client <= MaxClients && IsClientInGame(client))
		{
			//insert
			decl String:szSteamId[32];		
			decl String:szQuery[512];
			decl String:szUName[MAX_NAME_LENGTH];
			if (IsClientConnected(client))
			{
				GetClientAuthString(client, szSteamId, 32);
				GetClientName(client, szUName, MAX_NAME_LENGTH);
			}
			else
				return;			
			decl String:szName[MAX_NAME_LENGTH*2+1];      
			SQL_QuoteString(g_hDb, szUName, szName, MAX_NAME_LENGTH*2+1);	
			Format(szQuery, 512, sql_insertPlayerRank, szSteamId, szName,g_szCountry[client]); 
			SQL_TQuery(g_hDb, SQL_InsertCheckCallback, szQuery,DBPrio_Low);
		}
	}
}

public CalculatePlayerRank(client)
{
	decl String:szQuery[255];      
	decl String:szSteamId[32];
	g_pr_oldpoints[client] = g_pr_points[client];
	g_pr_points[client] = 0;
				
	if (client>MAXPLAYERS)
	{
		Format(szSteamId, 32, "%s", g_pr_szSteamID[client]); 
	}
	else
	{
		if (!g_bPointSystem || !IsClientInGame(client))
			return;
		GetClientAuthString(client, szSteamId, 32);
	}	
	Format(szQuery, 255, sql_selectRankedPlayer, szSteamId);    
	SQL_TQuery(g_hDb, sql_selectRankedPlayerCallback, szQuery,client);	
}

public sql_selectRankedPlayerCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	new client = data;
	decl String:szSteamId[32];
	if (client>MAXPLAYERS)
		Format(szSteamId, 32, "%s", g_pr_szSteamID[client]); 
	else
		GetClientAuthString(client, szSteamId, 32);
		
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{	
		//add multiplier points	
		g_pr_multiplier[client] = SQL_FetchInt(hndl, 5);
		if (g_pr_multiplier[client]>0)
			g_pr_points[client]+=  g_pr_points_finished*g_pr_multiplier[client];		

		//challenge ratios 
		if (client<=MAXPLAYERS && IsValidEntity(client) && IsClientConnected(client) && g_bchallengeConnected[client])
		{
			g_challenge_win_ratio[client] = SQL_FetchInt(hndl, 6);
			g_challenge_points_ratio[client] = SQL_FetchInt(hndl, 7);
			g_bchallengeConnected[client] = false;
		}
		//CountFinishedMapsTP
		decl String:szQuery[512];       
		Format(szQuery, 512, sql_CountFinishedMapsTP, szSteamId, szSteamId);  
		SQL_TQuery(g_hDb, sql_CountFinishedMapsTPCallback, szQuery, client);
	}
	else
	{
		if (client <= MaxClients)
		{
			g_pr_players++;			
			//insert
			decl String:szQuery[255];
			decl String:szUName[MAX_NAME_LENGTH];
			GetClientName(client, szUName, MAX_NAME_LENGTH);
			decl String:szName[MAX_NAME_LENGTH*2+1];      
			SQL_QuoteString(g_hDb, szUName, szName, MAX_NAME_LENGTH*2+1);
			Format(szQuery, 255, sql_insertPlayerRank, szSteamId, szName,g_szCountry[client]); 
			SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery, DBPrio_Low);
			g_pr_multiplier[client] = 0;
			g_pr_finishedmaps_pro[client] = 0;
			g_pr_finishedmaps_tp[client] = 0;
			g_pr_finishedmaps_pro_perc[client] = 0.0;
			g_pr_finishedmaps_tp_perc[client] = 0.0;
		}
	}
}

public sql_CountFinishedMapsTPCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	new client = data;
	decl String:szQuery[512];   
	decl String:szSteamId[32];
	decl String:MapName[MAX_MAP_LENGTH];
	decl String:MapName2[MAX_MAP_LENGTH];
	new finished_TP=0;
	
	if (client>MAXPLAYERS)
		Format(szSteamId, 32, "%s", g_pr_szSteamID[client]); 
	else
		GetClientAuthString(client, szSteamId, 32);
	
	if(SQL_HasResultSet(hndl))
	{
		while (SQL_FetchRow(hndl))
		{
			SQL_FetchString(hndl, 0, MapName, MAX_MAP_LENGTH);	
			for (new i = 0; i < GetArraySize(g_MapList); i++)
			{
				GetArrayString(g_MapList, i, MapName2, sizeof(MapName2));
				if (StrEqual(MapName2, MapName, false))
				{
					finished_TP++;
					continue;
				}
			}			
		}	
		g_pr_finishedmaps_tp[client]=finished_TP;	
		g_pr_finishedmaps_tp_perc[client]= (float(finished_TP) / float(g_pr_mapcount)) * 100.0;
	
		//CountFinishedMapsPro
		Format(szQuery, 512, sql_CountFinishedMapsPro, szSteamId, szSteamId);  
		SQL_TQuery(g_hDb, sql_CountFinishedMapsProCallback, szQuery, client);			
	}	
}

public sql_CountFinishedMapsProCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	new client = data;
	decl String:szQuery[512];   
	decl String:szSteamId[32];
	decl String:MapName[MAX_MAP_LENGTH];
	decl String:MapName2[MAX_MAP_LENGTH];
	new finished_Pro=0;
	
	if (client>MAXPLAYERS)
		Format(szSteamId, 32, "%s", g_pr_szSteamID[client]); 
	else
		GetClientAuthString(client, szSteamId, 32);

	if(SQL_HasResultSet(hndl))
	{	
		while (SQL_FetchRow(hndl))
		{
			SQL_FetchString(hndl, 0, MapName, MAX_MAP_LENGTH);	
			for (new i = 0; i < GetArraySize(g_MapList); i++)
			{
				GetArrayString(g_MapList, i, MapName2, sizeof(MapName2));
				if (StrEqual(MapName2, MapName, false))
				{
					finished_Pro++;
					continue;
				}
			}			
		}
		g_pr_finishedmaps_pro[client]=finished_Pro;
		g_pr_finishedmaps_pro_perc[client]= (float(finished_Pro) / float(g_pr_mapcount)) * 100.0;	

		//overall count
		new pr_finishedmaps = g_pr_finishedmaps_tp[client]+g_pr_finishedmaps_pro[client];
		new Float:pr_finishedmaps_perc = (float(pr_finishedmaps) / (float(g_pr_mapcount*2))) * 100.0;
		g_pr_points[client]+= RoundToCeil(pr_finishedmaps_perc *(g_pr_dyn_maxpoints * 0.0015));
		//bonus points
		if (pr_finishedmaps_perc== 100.0)
			g_pr_points[client]+= RoundToNearest(g_pr_rank_Master/4.0);			
		Format(szQuery, 512, sql_selectPersonalAllRecords, szSteamId, szSteamId);  
		SQL_TQuery(g_hDb, sql_selectPersonalAllRecordsCallback, szQuery, client);		
	}	
}

public sql_selectPersonalAllRecordsCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	decl String:szQuery[512];  
	new client = data;
	decl String:szSteamId[32];
	if (client>MAXPLAYERS)
		Format(szSteamId, 32, "%s", g_pr_szSteamID[client]); 
	else
		GetClientAuthString(client, szSteamId, 32);
	
	decl String:szMapName[MAX_MAP_LENGTH];
	if(SQL_HasResultSet(hndl))
	{	
		
		g_pr_maprecords_row_counter[client]=0;
		g_pr_maprecords_row_count[client] = SQL_GetRowCount(hndl);
		new teleports;
		while (SQL_FetchRow(hndl))
		{		
			SQL_FetchString(hndl, 2, szMapName, MAX_MAP_LENGTH);			
			teleports = SQL_FetchInt(hndl, 4);	
			if (teleports > 0)
				Format(szQuery, 512, sql_selectPlayerRankTime, szSteamId, szMapName, szMapName);
			else
				Format(szQuery, 512, sql_selectPlayerRankProTime, szSteamId, szMapName, szMapName);
			SQL_TQuery(g_hDb, sql_selectPlayerRankCallback, szQuery, client);								
		}	
		
		if (g_pr_maprecords_row_count[client]==0)
		{
			new Float: max = g_pr_dyn_maxpoints * 0.05;
			new r;
			if (g_LjRank[client]<21 && g_LjRank[client] > 0)
			{
				r = g_LjRank[client] * 4;
				g_pr_points[client]+= RoundToCeil((1.01-(float(r)/100.0))*max);
			}
			if (g_BhopRank[client]<21 && g_BhopRank[client] > 0)
			{
				r = g_BhopRank[client] * 4;
				g_pr_points[client]+= RoundToCeil((1.01-(float(r)/100.0))*max);
			}
			if (g_wjRank[client]<21 && g_wjRank[client] > 0)
			{
				r = g_wjRank[client] * 4;
				g_pr_points[client]+= RoundToCeil((1.01-(float(r)/100.0))*max);
			}
			if (g_DropBhopRank[client]<21 && g_DropBhopRank[client] > 0)
			{
				r = g_DropBhopRank[client] * 4;
				g_pr_points[client]+= RoundToCeil((1.01-(float(r)/100.0))*max);
			}
			if (g_MultiBhopRank[client]<21 && g_MultiBhopRank[client] > 0)
			{
				r = g_MultiBhopRank[client] * 4;
				g_pr_points[client]+= RoundToCeil((1.01-(float(r)/100.0))*max);
			}
			db_updatePoints(client);		
		}
	}	
}

public 	sql_selectPlayerRankCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	decl String:szMapName[MAX_MAP_LENGTH];
	decl String:szMapName2[MAX_MAP_LENGTH];
	new client = data;
	g_pr_maprecords_row_counter[client]++;
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		SQL_FetchString(hndl, 2, szMapName, MAX_MAP_LENGTH);	
		for (new i = 0; i < GetArraySize(g_MapList); i++)
		{
			GetArrayString(g_MapList, i, szMapName2, sizeof(szMapName2));
			if (StrEqual(szMapName2, szMapName, false))
			{
				new rank = SQL_GetRowCount(hndl);
				new teleports = SQL_FetchInt(hndl, 1);	
				if (rank <101)
				{
					new max = RoundToCeil(g_pr_dyn_maxpoints * 0.005);
					new Float:rankperc = (101.0-rank) / 100.0;
					if (teleports > 0)
						g_pr_points[client]+= RoundToCeil(float(max) * rankperc);
					else
						g_pr_points[client]+= RoundToCeil((float(max) * rankperc)*2);	
				}
				continue;
			}
		}
	}
	if (g_pr_maprecords_row_counter[client]==g_pr_maprecords_row_count[client])
	{
		new Float: max = g_pr_dyn_maxpoints * 0.05;
		new r;
		if (g_LjRank[client]<21 && g_LjRank[client] > 0)
		{
			r = g_LjRank[client] * 4;
			g_pr_points[client]+= RoundToCeil((1.01-(float(r)/100.0))*max);
		}
		if (g_BhopRank[client]<21 && g_BhopRank[client] > 0)
		{
			r = g_BhopRank[client] * 4;
			g_pr_points[client]+= RoundToCeil((1.01-(float(r)/100.0))*max);
		}
		if (g_wjRank[client]<21 && g_wjRank[client] > 0)
		{
			r = g_wjRank[client] * 4;
			g_pr_points[client]+= RoundToCeil((1.01-(float(r)/100.0))*max);
		}
		if (g_DropBhopRank[client]<21 && g_DropBhopRank[client] > 0)
		{
			r = g_DropBhopRank[client] * 4;
			g_pr_points[client]+= RoundToCeil((1.01-(float(r)/100.0))*max);
		}
		if (g_MultiBhopRank[client]<21 && g_MultiBhopRank[client] > 0)
		{
			r = g_MultiBhopRank[client] * 4;
			g_pr_points[client]+= RoundToCeil((1.01-(float(r)/100.0))*max);
		}
		db_updatePoints(client);		
	}
}
/////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////UDPATE METHODS
public db_updatePoints(client)
{
	decl String:szQuery[255];
	decl String:szName[MAX_NAME_LENGTH];	
	decl String:szSteamId[32];	
	if (client>MAXPLAYERS)
	{
		Format(szQuery, 255, sql_updatePlayerRankPoints, g_pr_szName[client], g_pr_points[client], g_pr_finishedmaps_tp[client],g_pr_finishedmaps_pro[client], g_pr_szSteamID[client]); 
		SQL_TQuery(g_hDb, sql_updatePlayerRankPointsCallback, szQuery, client);
	}
	else
	{
		if (IsClientConnected(client))
		{
			GetClientName(client, szName, MAX_NAME_LENGTH);	
			GetClientAuthString(client, szSteamId, 32);
			Format(szQuery, 255, sql_updatePlayerRankPoints2, szName, g_pr_points[client], g_pr_finishedmaps_tp[client],g_pr_finishedmaps_pro[client],g_challenge_win_ratio[client],g_challenge_points_ratio[client],g_szCountry[client], szSteamId); 
			SQL_TQuery(g_hDb, sql_updatePlayerRankPointsCallback, szQuery, client, DBPrio_Low);
		}
	}	
}


public sql_updatePlayerRankPointsCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	
	new client = data;
	if (client>MAXPLAYERS)
	{
		g_i++;	
		
		//console info
		if (g_bManualRecalc && IsValidEntity(g_bManualRecalcClientID) && IsClientInGame(g_bManualRecalcClientID))
			PrintToConsole(g_bManualRecalcClientID, "%i/%i",g_i,g_pr_rowcount); 
		if (g_i==g_pr_rowcount && g_pr_refreshingDB)
		{
			g_pr_rowcount++;
			for (new i = 1; i <= MaxClients; i++)
				if (1 <= i <= MaxClients && IsValidEntity(i) && IsClientInGame(i))
					PrintToChat(i, "%t", "PrUpdateFinished", MOSSGREEN, WHITE, LIMEGREEN);
			g_bManualRecalc=false;
			g_pr_refreshingDB=false;
		}
	}
	else
	{
		if (g_brc_PlayerRank[client] && client <= MAXPLAYERS)
		{
			ProfileMenu(client, -1);
			PrintToChat(client, "%t", "Rc_PlayerRankFinished", MOSSGREEN,WHITE,GRAY,PURPLE,g_pr_points[client],GRAY);	
			g_brc_PlayerRank[client]=false;
		}
		if (client <= MAXPLAYERS && IsClientInGame(client) && g_pr_showmsg[client])
		{	
			decl String:szName[MAX_NAME_LENGTH];	
			GetClientName(client, szName, MAX_NAME_LENGTH);	
			new diff = g_pr_points[client] - g_pr_oldpoints[client];	
			if (diff > 0)
			{
				for (new i = 1; i <= MaxClients; i++)
					if (1 <= i <= MaxClients && IsClientInGame(i) && IsValidEntity(i))
						PrintToChat(i, "%t", "EarnedPoints", MOSSGREEN, WHITE, PURPLE,szName, GRAY, PURPLE, diff,GRAY,PURPLE, g_pr_points[client], GRAY);
			}
			g_pr_showmsg[client]=false;
		}	
		CreateTimer(1.0, SetClanTag, client,TIMER_FLAG_NO_MAPCHANGE);			
	}
}

public db_updateStat(client) 
{
	decl String:szQuery[512];
	decl String:szSteamId[32];
	GetClientAuthString(client, szSteamId, 32);
	new finishedmaps=g_pr_finishedmaps_pro[client]+g_pr_finishedmaps_tp[client];
	Format(szQuery, 512, sql_updatePlayerRank, finishedmaps, g_pr_finishedmaps_tp[client],g_pr_finishedmaps_pro[client],g_pr_multiplier[client],g_challenge_win_ratio[client],g_challenge_points_ratio[client],szSteamId); 
	SQL_TQuery(g_hDb, SQL_UpdateStatCallback, szQuery, client, DBPrio_Low);
	
}


public db_selectRankedPlayer(String:szSteamId[32], bet)
{
	decl String:szQuery[512];      
	new Handle:pack = CreateDataPack();
	WritePackCell(pack, bet);
	Format(szQuery, 512, sql_selectRankedPlayer, szSteamId); 
	SQL_TQuery(g_hDb, db_selectRankedPlayerCallback, szQuery, pack,DBPrio_Low);
}

public db_selectRankedPlayerCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	new Handle:pack = data;
	ResetPack(pack);
	new bet = ReadPackCell(pack);   
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		decl String:szQuery[512];
		decl String:szSteamId[32];
		SQL_FetchString(hndl, 0, szSteamId, 32);
		new multiplier = SQL_FetchInt(hndl, 5); 
		new winratio = SQL_FetchInt(hndl, 6); 
		new pointsratio = SQL_FetchInt(hndl, 7); 
		multiplier = multiplier - bet;
		winratio--;
		pointsratio= pointsratio - (bet*g_pr_points_finished)
		
		Format(szQuery, 512, sql_updatePlayerRankChallenge, multiplier,winratio,pointsratio,szSteamId); 
		SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery, DBPrio_Low);
	}	
	CloseHandle(pack);
}

public SQL_UpdateStatCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	new client = data;
	CalculatePlayerRank(client);
}


public db_viewMapRankPro(client)
{
	decl String:szQuery[512];
	decl String:szSteamId[32];
	if (IsClientConnected(client))
		GetClientAuthString(client, szSteamId, 32);
	else
		return;
	Format(szQuery, 512, sql_selectPlayerRankProTime, szSteamId, g_szMapName, g_szMapName);
	SQL_TQuery(g_hDb, db_viewMapRankProCallback, szQuery, client);
}

public db_viewMapRankProCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	new client = data;  
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
		g_maprank_pro[client] = SQL_GetRowCount(hndl); 
	if (g_bMapRankToChat[client])
			MapFinishedMsgs(client, 1);		
}

public db_viewMapProRankCount()
{
	decl String:szQuery[512];
	Format(szQuery, 512, sql_selectPlayerProCount, g_szMapName);
	SQL_TQuery(g_hDb, sql_selectPlayerProCountCallback, szQuery);
}
public sql_selectPlayerProCountCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
		g_maptimes_pro = SQL_GetRowCount(hndl);
}

public db_viewMapRankTp(client)
{
	decl String:szQuery[512];
	decl String:szSteamId[32];
	if (IsClientConnected(client))
		GetClientAuthString(client, szSteamId, 32);
	else
		return;
	Format(szQuery, 512, sql_selectPlayerRankTime, szSteamId, g_szMapName, g_szMapName);
	SQL_TQuery(g_hDb, db_viewMapRankTpCallback, szQuery, client);
}

public db_viewMapRankTpCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	new client = data;  
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
		g_maprank_tp[client] = SQL_GetRowCount(hndl); 
	if (g_bMapRankToChat[client])
			MapFinishedMsgs(client, 0);
}

public db_viewMapTpRankCount()
{
	decl String:szQuery[512];
	Format(szQuery, 512, sql_selectPlayerCount, g_szMapName);
	SQL_TQuery(g_hDb, sql_selectPlayerCountCallback, szQuery);	
}

public sql_selectPlayerCountCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
		g_maptimes_tp = SQL_GetRowCount(hndl);
}
//////////////////////////////////////////////////////
/////////////////TOP 100 PLAYERS
public db_selectTopChallengers(client)
{
	decl String:szQuery[128];       
	Format(szQuery, 128, sql_selectTopChallengers);   
	SQL_TQuery(g_hDb, sql_selectTopChallengersCallback, szQuery, client);
}

public sql_selectTopChallengersCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{       
	new client = data;
	decl String:szValue[64];
	decl String:szName[MAX_NAME_LENGTH];
	decl String:szWinRatio[32];
	decl String:szSteamID[32];
	decl String:szPointsRatio[32];
	new winratio;
	new pointsratio;
	new Handle:menu = CreateMenu(TopChallengeHandler1);
	SetMenuPagination(menu, 5); 
	SetMenuTitle(menu, "Top 5 Challengers\n#   W/L P.-Ratio    Player (W/L ratio)");     
	if(SQL_HasResultSet(hndl))
	{
		new i = 1;
		while (SQL_FetchRow(hndl))
		{	
			SQL_FetchString(hndl, 0, szName, MAX_NAME_LENGTH);
			winratio = SQL_FetchInt(hndl, 1); 
			pointsratio = SQL_FetchInt(hndl, 2); 
			SQL_FetchString(hndl, 3, szSteamID, 32);			
			if (winratio>=0)
				Format(szWinRatio, 32, "+%i",winratio);
			else
				Format(szWinRatio, 32, "%i",winratio);
			
			if (pointsratio>=0)
				Format(szPointsRatio, 32, "+%ip",pointsratio);
			else
				Format(szPointsRatio, 32, "%ip",pointsratio);
			


			
			if (pointsratio  < 10)
				Format(szValue, 64, "       %s         » %s (%s)", szPointsRatio, szName,szWinRatio);
			else
				if (pointsratio  < 100)
					Format(szValue, 64, "       %s       » %s (%s)", szPointsRatio, szName,szWinRatio);		
				else
					if (pointsratio  < 1000)
						Format(szValue, 64, "       %s     » %s (%s)", szPointsRatio, szName,szWinRatio);		
					else
						if (pointsratio  < 10000)
							Format(szValue, 64, "       %s   » %s (%s)", szPointsRatio, szName,szWinRatio);	
			AddMenuItem(menu, szSteamID, szValue, ITEMDRAW_DEFAULT);
			i++;
		}
		if(i == 1)
		{
			PrintToChat(client, "%t", "NoPlayerTop", MOSSGREEN,WHITE);
			TopMenu(client);
		}
		else
		{
			SetMenuOptionFlags(menu, MENUFLAG_BUTTON_EXIT);
			DisplayMenu(menu, client, MENU_TIME_FOREVER);
		}
	}
	else
	{
		PrintToChat(client, "%t", "NoPlayerTop", MOSSGREEN,WHITE);
		TopMenu(client);
	}
}

public db_selectTopProRecordHolders(client)
{
	decl String:szQuery[512];       
	Format(szQuery, 512, sql_selectProRecordHolders);   
	SQL_TQuery(g_hDb, db_sql_selectProRecordHoldersCallback, szQuery, client);
}

public db_sql_selectProRecordHoldersCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{       
	new client = data;
	decl String:szSteamID[32];
	decl String:szRecords[64];
	decl String:szQuery[256]; 
	new records=0;	 
	if(SQL_HasResultSet(hndl))
	{
		new i = SQL_GetRowCount(hndl);
		g_hTopJumpersMenu[client] = CreateMenu(TopProHoldersHandler1);
		SetMenuTitle(g_hTopJumpersMenu[client], "Top 5 Pro Jumpers\n#   Records       Player");   
		while (SQL_FetchRow(hndl))
		{		
			SQL_FetchString(hndl, 0, szSteamID, 32);
			records = SQL_FetchInt(hndl, 1); 
			if (records > 9)
				Format(szRecords,64, "%i", records);
			else
				Format(szRecords,64, "%i  ", records);	
				
			new Handle:pack = CreateDataPack();
			WritePackCell(pack, client);
			WritePackString(pack, szRecords);
			WritePackCell(pack, i);
			WritePackString(pack, szSteamID);
			Format(szQuery, 256, sql_selectRankedPlayer, szSteamID);
			SQL_TQuery(g_hDb, db_sql_selectProRecordHoldersCallback2, szQuery, pack);
			i--;
		}
	}
	else
	{
		PrintToChat(client, "%t", "NoRecordTop", MOSSGREEN,WHITE);
		TopMenu(client);
	}
}

public db_sql_selectProRecordHoldersCallback2(Handle:owner, Handle:hndl, const String:error[], any:data)
{       
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		decl String:szName[MAX_NAME_LENGTH];
		decl String:szSteamID[32];
		decl String:szRecords[64];
		decl String:szValue[128];
		new Handle:pack = data;
		ResetPack(pack);
		new client = ReadPackCell(pack);      
		ReadPackString(pack, szRecords, 64);	
		new count = ReadPackCell(pack); 
		ReadPackString(pack, szSteamID, 32);	
		CloseHandle(pack);
		SQL_FetchString(hndl, 1, szName, MAX_NAME_LENGTH);
		Format(szValue, 128, "      %s       »  %s",szRecords, szName);
		AddMenuItem(g_hTopJumpersMenu[client], szSteamID, szValue, ITEMDRAW_DEFAULT);
		if (count==1)
		{
			SetMenuOptionFlags(g_hTopJumpersMenu[client], MENUFLAG_BUTTON_EXIT);
			DisplayMenu(g_hTopJumpersMenu[client], client, MENU_TIME_FOREVER);
		}
	}	
}

public db_selectTopTpRecordHolders(client)
{
	decl String:szQuery[512];       
	Format(szQuery, 512, sql_selectTpRecordHolders);   
	SQL_TQuery(g_hDb, db_sql_selectTpRecordHoldersCallback, szQuery, client);
}

public db_sql_selectTpRecordHoldersCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{       
	new client = data;
	decl String:szSteamID[32];
	decl String:szRecords[64];
	decl String:szQuery[256]; 
	new records=0;	 
	if(SQL_HasResultSet(hndl))
	{
		new i = SQL_GetRowCount(hndl);
		g_hTopJumpersMenu[client] = CreateMenu(TopTpHoldersHandler1);
		SetMenuTitle(g_hTopJumpersMenu[client], "Top 5 TP Jumpers\n#   Records       Player");   
		while (SQL_FetchRow(hndl))
		{		
			SQL_FetchString(hndl, 0, szSteamID, 32);
			records = SQL_FetchInt(hndl, 1); 
			if (records > 9)
				Format(szRecords,64, "%i", records);
			else
				Format(szRecords,64, "%i  ", records);	
				
			new Handle:pack = CreateDataPack();
			WritePackCell(pack, client);
			WritePackString(pack, szRecords);
			WritePackCell(pack, i);
			WritePackString(pack, szSteamID);
			Format(szQuery, 256, sql_selectRankedPlayer, szSteamID);
			SQL_TQuery(g_hDb, db_sql_selectTpRecordHoldersCallback2, szQuery, pack);
			i--;
		}
	}
	else
	{
		PrintToChat(client, "%t", "NoRecordTop", MOSSGREEN,WHITE);
		TopMenu(client);
	}
}

public db_sql_selectTpRecordHoldersCallback2(Handle:owner, Handle:hndl, const String:error[], any:data)
{       
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		decl String:szName[MAX_NAME_LENGTH];
		decl String:szSteamID[32];
		decl String:szRecords[64];
		decl String:szValue[128];
		new Handle:pack = data;
		ResetPack(pack);
		new client = ReadPackCell(pack);      
		ReadPackString(pack, szRecords, 64);	
		new count = ReadPackCell(pack); 
		ReadPackString(pack, szSteamID, 32);
		CloseHandle(pack);
		SQL_FetchString(hndl, 1, szName, MAX_NAME_LENGTH);
		Format(szValue, 128, "      %s       »  %s",szRecords, szName);
		AddMenuItem(g_hTopJumpersMenu[client], szSteamID, szValue, ITEMDRAW_DEFAULT);
		if (count==1)
		{
			SetMenuOptionFlags(g_hTopJumpersMenu[client], MENUFLAG_BUTTON_EXIT);
			DisplayMenu(g_hTopJumpersMenu[client], client, MENU_TIME_FOREVER);			
		}
	}	
}


public db_selectTopPlayers(client)
{
	decl String:szQuery[128];       
	Format(szQuery, 128, sql_selectTopPlayers);   
	SQL_TQuery(g_hDb, db_selectTop100PlayersCallback, szQuery, client);
}

public db_selectTop100PlayersCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{       
	new client = data;
	decl String:szValue[128];
	decl String:szName[64];
	decl String:szRank[16];
	decl String:szSteamID[32];
	decl String:szPerc[16];
	new points;
	new Handle:menu = CreateMenu(TopPlayersMenuHandler1);
	SetMenuPagination(menu, 5); 
	SetMenuTitle(menu, "Top 100 Players\n    Rank   Points         Maps            Player");     
	if(SQL_HasResultSet(hndl))
	{
		new i = 1;
		while (SQL_FetchRow(hndl))
		{	
			SQL_FetchString(hndl, 0, szName, 64);
			if (i==100)
				Format(szRank, 16, "[%i.]",i);
			else
			if (i<10)
				Format(szRank, 16, "[0%i.]  ",i);
			else
				Format(szRank, 16, "[%i.]  ",i);
			points = SQL_FetchInt(hndl, 1); 
			new pro = SQL_FetchInt(hndl, 2); 
			new tp = SQL_FetchInt(hndl, 3); 
			SQL_FetchString(hndl, 4, szSteamID, 32);				
			new Float:fperc;
			if (g_bAllowCheckpoints)
				fperc =  (float(pro+tp) / (float(g_pr_mapcount*2))) * 100.0;
			else
				fperc =  (float(pro) / (float(g_pr_mapcount))) * 100.0;
				
			if (fperc<10.0)
				Format(szPerc, 16, "  %.1f%c  ",fperc,PERCENT);
			else
				if (fperc== 100.0)
					Format(szPerc, 16, "100.0%c",PERCENT);
				else
					if (fperc> 100.0) //player profile not refreshed after removing maps
						Format(szPerc, 16, "100.0%c",PERCENT);
					else
						Format(szPerc, 16, "%.1f%c  ",fperc,PERCENT);
						
			if (points  < 10)
				Format(szValue, 128, "%s      %ip       %s     » %s",szRank, points, szPerc,szName);
			else
				if (points  < 100)
					Format(szValue, 128, "%s     %ip       %s     » %s",szRank, points, szPerc,szName);		
				else
					if (points  < 1000)
						Format(szValue, 128, "%s   %ip       %s     » %s",szRank, points, szPerc,szName);		
					else
						if (points  < 10000)
							Format(szValue, 128, "%s %ip       %s     » %s",szRank, points, szPerc,szName);	
						else
							if (points  < 100000)
								Format(szValue, 128, "%s %ip     %s     » %s",szRank, points, szPerc,szName);	
							else
								Format(szValue, 128, "%s %ip   %s     » %s",szRank, points, szPerc,szName);	
			
			AddMenuItem(menu, szSteamID, szValue, ITEMDRAW_DEFAULT);
			i++;
		}
		if(i == 1)
		{
			PrintToChat(client, "%t", "NoPlayerTop", MOSSGREEN,WHITE);
		}
		else
		{
			SetMenuOptionFlags(menu, MENUFLAG_BUTTON_EXIT);
			DisplayMenu(menu, client, MENU_TIME_FOREVER);
		}
	}
	else
	{
		PrintToChat(client, "%t", "NoPlayerTop", MOSSGREEN,WHITE);
	}
}