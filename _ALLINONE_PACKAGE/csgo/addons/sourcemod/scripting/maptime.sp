#pragma semicolon 1
#include <sourcemod>

public Plugin:myinfo = 
{
        name = "MapTime",
        author = "1NutWunDeR",
        description = "private",
        version = "1.0",
        url = ""
}

public OnPluginStart()
{
}

public OnMapStart()
{
	decl String:szMapName[128];
	GetCurrentMap(szMapName, 128);
	
	//fix workshop map name
	new String:mapPieces[6][128];
	new lastPiece = ExplodeString(szMapName, "/", mapPieces, sizeof(mapPieces), sizeof(mapPieces[])); 
	Format(szMapName, sizeof(szMapName), "%s", mapPieces[lastPiece-1]); 
   	
	if (StrEqual(szMapName,"kz_7in1_go"))
	{
		ServerCommand("mp_timelimit 60");
		ServerCommand("mp_roundtime 60");
		ServerCommand("mp_restartgame 1");
	}
	else
	if (StrEqual(szMapName,"kz_beginnerblock_go"))
	{
		ServerCommand("mp_timelimit 15");
		ServerCommand("mp_roundtime 15");
		ServerCommand("mp_restartgame 1");
	}
	else
	if (StrEqual(szMapName,"kz_minimountain_go"))
	{
		ServerCommand("mp_timelimit 15");
		ServerCommand("mp_roundtime 15");
		ServerCommand("mp_restartgame 1");
	}
	else	
	if (StrEqual(szMapName,"xc_powerblock_rc1"))
	{
		ServerCommand("mp_timelimit 50");
		ServerCommand("mp_roundtime 50");
		ServerCommand("mp_restartgame 1");
	}
	else	
	if (StrEqual(szMapName,"kz_toonadventure_go"))
	{
		ServerCommand("mp_timelimit 60");
		ServerCommand("mp_roundtime 60");
		ServerCommand("mp_restartgame 1");
	}
	else	
	if (StrEqual(szMapName,"kz_spiritblockv2"))
	{
		ServerCommand("mp_timelimit 20");
		ServerCommand("mp_roundtime 20");
		ServerCommand("mp_restartgame 1");
	}
	else	
	if (StrEqual(szMapName,"kz_quadrablock"))
	{
		ServerCommand("mp_timelimit 60");
		ServerCommand("mp_roundtime 60");
		ServerCommand("mp_restartgame 1");
	}
	else	
	if (StrEqual(szMapName,"kz_olympus"))
	{
		ServerCommand("mp_timelimit 25");
		ServerCommand("mp_roundtime 25");
		ServerCommand("mp_restartgame 1");
	}
	else	
	if (StrEqual(szMapName,"bhop_FreAkin"))
	{
		ServerCommand("mp_timelimit 60");
		ServerCommand("mp_roundtime 60");
		ServerCommand("mp_restartgame 1");
	}
	else	
	if (StrEqual(szMapName,"surf_kz_protraining"))
	{
		ServerCommand("mp_timelimit 60");
		ServerCommand("mp_roundtime 60");
		ServerCommand("mp_restartgame 1");
	}
}


