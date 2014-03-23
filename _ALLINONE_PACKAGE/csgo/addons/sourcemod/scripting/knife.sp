#pragma semicolon 1
#include <sourcemod>
#include <smlib>
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
        name = "MapTime",
        author = "1NutWunDeR",
        description = "",
        version = "1.0",
        url = ""
}

public OnPluginStart()
	RegConsoleCmd("sm_knife", Client_Knife);

public Action:Client_Knife(client, args)
{
	if(!IsPlayerAlive(client))
		return Plugin_Handled;
	KnifeMenu(client);
	return Plugin_Handled;
}

public OnClientPostAdminCheck(client)
{	
	CreateTimer(66.0, KnifeInfoMsg, client,TIMER_FLAG_NO_MAPCHANGE);
}

public Action:KnifeInfoMsg(Handle:timer, any:client)
{
	if (IsClientInGame(client))
		PrintToChat(client,"You can choose your knife skin with %c!knife",GREEN);
}

public KnifeMenu(client)
{
	new Handle:knifemenu = CreateMenu(KnifeMenuHandler);
	SetMenuTitle(knifemenu, "Choose your knife");	
	AddMenuItem(knifemenu, "", "Bayonet");
	AddMenuItem(knifemenu, "", "Gut knife");
	AddMenuItem(knifemenu, "", "M9 Bayonet");
	AddMenuItem(knifemenu, "", "Flip knife");
	AddMenuItem(knifemenu, "", "Karambit");	
	AddMenuItem(knifemenu, "", "Golden");	
	AddMenuItem(knifemenu, "", "Default");
	SetMenuOptionFlags(knifemenu, MENUFLAG_BUTTON_EXIT);
	DisplayMenu(knifemenu, client, MENU_TIME_FOREVER);
}

public KnifeMenuHandler(Handle:menu, MenuAction:action, param1,param2)
{
	if(action == MenuAction_Select)
	{
		switch(param2)
		{
			
			case 0: Give_knife(param1, "weapon_bayonet");
			case 1: Give_knife(param1, "weapon_knife_gut");
			case 2: Give_knife(param1, "weapon_knife_m9_bayonet");
			case 3: Give_knife(param1, "weapon_knife_flip");
			case 4: Give_knife(param1, "weapon_knife_karambit");	
			case 5: Give_knife(param1, "weapon_knifegg");	
			case 6: Give_knife(param1, "weapon_knife");			
		}
		if (IsPlayerAlive(param1))		
			KnifeMenu(param1);
	}
}

public Give_knife(client, String:szKnifeName[32])
{
	if (!IsClientInGame(client) || !IsPlayerAlive(client))
		return;
	new currentknife = GetPlayerWeaponSlot(client, 2);
	if(IsValidEntity(currentknife) && currentknife != INVALID_ENT_REFERENCE)
	{
		RemovePlayerItem(client, currentknife);
		RemoveEdict(currentknife);	
	}
	new knife = GivePlayerItem(client, szKnifeName);
	EquipPlayerWeapon(client, knife);
}
