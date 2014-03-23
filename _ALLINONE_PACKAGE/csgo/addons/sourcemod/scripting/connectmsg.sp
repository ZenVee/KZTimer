#pragma semicolon 1
#include <sourcemod>
#include <geoip>
#define WHITE 0x01
#define DARKRED 0x02
#define PURPLE 0x03
#define GREEN 0x04
#define MOSSGREEN 0x05
#define LIMEGREEN 0x06
#define RED 0x07
#define GRAY 0x08
#define YELLOW 0x09

public Plugin:myinfo = 
{
        name = "ConnectMsg",
        author = "1NutWunDeR",
        description = "The new messages show the clients name & country",
        version = "1.0",
        url = ""
}

public OnClientAuthorized(client)
{
	decl String:s_Country[32];
	decl String:s_clientName[32];
	decl String:s_address[32];		
	GetClientIP(client, s_address, 32);
	GetClientName(client, s_clientName, 32);
	Format(s_Country, 100, "Unknown");
	if(!IsFakeClient(client))
	{
		GeoipCountry(s_address, s_Country, 100);     
		if(!strcmp(s_Country, NULL_STRING))
			Format( s_Country, 100, "Unknown", s_Country );
		else				
			if( StrContains( s_Country, "United", false ) != -1 || 
				StrContains( s_Country, "Republic", false ) != -1 || 
				StrContains( s_Country, "Federation", false ) != -1 || 
				StrContains( s_Country, "Island", false ) != -1 || 
				StrContains( s_Country, "Netherlands", false ) != -1 || 
				StrContains( s_Country, "Isle", false ) != -1 || 
				StrContains( s_Country, "Bahamas", false ) != -1 || 
				StrContains( s_Country, "Maldives", false ) != -1 || 
				StrContains( s_Country, "Philippines", false ) != -1 || 
				StrContains( s_Country, "Vatican", false ) != -1 )
			{
				Format( s_Country, 100, "The %s", s_Country );
			}				
		
	}	
	if (StrEqual(s_Country, "Unknown",false) || StrEqual(s_Country, "Localhost",false))
	{
		if(IsFakeClient(client))
			PrintToChatAll("BOT %s %cconnected%c.",s_clientName, GREEN,GRAY);
		else
			PrintToChatAll("Player %s %cconnected%c.",s_clientName, GREEN,GRAY);
	}
	else
		PrintToChatAll( "Player %s %cconnected from%c %s.", s_clientName, GREEN,GRAY,s_Country);
}
