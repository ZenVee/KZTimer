#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <cstrike>
#undef REQUIRE_EXTENSIONS
#define REQUIRE_EXTENSIONS
#define WHITE 0x01
#define DARKRED 0x02
#define PURPLE 0x03
#define GREEN 0x04
#define MOSSGREEN 0x05
#define LIMEGREEN 0x06
#define RED 0x07
#define BLUE 0x08
#define YELLOW 0x09
#define VERSION "1.0"

public Plugin:myinfo =
{
	name = "MapchangeForcer",
	author = "1NutWunDeR",
	description = "",
	version = VERSION,
	url = ""
};


public OnPluginStart()
{
	CreateTimer(1.0, CheckTime, INVALID_HANDLE, TIMER_REPEAT);	
}

public OnMapStart()
{
	ServerCommand("mp_endmatch_votenextmap 0;mp_endmatch_votenextleveltime 5;mp_maxrounds 1;mp_match_end_changelevel 1;mp_match_can_clinch 0;mp_halftime 0");
}
public Action:CheckTime(Handle:timer)
{
	new timeleft;
	GetMapTimeLeft(timeleft);
	if (timeleft==600)
		PrintToChatAll("[%cMAP%c] 10 minutes remaining",DARKRED,WHITE);
	if (timeleft==300)
		PrintToChatAll("[%cMAP%c] 5 minutes remaining",DARKRED,WHITE);
	if (timeleft==120)
		PrintToChatAll("[%cMAP%c] 2 minutes remaining",DARKRED,WHITE);	
	if (timeleft==60)
		PrintToChatAll("[%cMAP%c] 60 seconds remaining",DARKRED,WHITE);
	if (timeleft==30)
		PrintToChatAll("[%cMAP%c] 30 seconds remaining",DARKRED,WHITE);
	if (timeleft==15)
		PrintToChatAll("[%cMAP%c] 15 seconds remaining",DARKRED,WHITE);
	if (timeleft==5)
		PrintToChatAll("[%cMAP%c] 5..",DARKRED,WHITE);
	if (timeleft==4)
		PrintToChatAll("[%cMAP%c] 4.",DARKRED,WHITE);
	if (timeleft==3)
		PrintToChatAll("[%cMAP%c] 3..",DARKRED,WHITE);
	if (timeleft==2)
	{
		ServerCommand("mp_ignore_round_win_conditions 0");
		PrintToChatAll("[%cMAP%c] 2..",DARKRED,WHITE);
	}
	if (timeleft==1)
		PrintToChatAll("[%cMAP%c] 1..",DARKRED,WHITE);
	if (timeleft==-2)
	{	
		for (new client = 1; client <= MaxClients; client++)
		{				
		    if(IsClientConnected(client) && IsClientInGame(client) && IsPlayerAlive(client))
			{
				SlapPlayer(client,999999,false);
			}
		}
	}
}
