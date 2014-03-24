// misc.sp

stock FakePrecacheSound( const String:szPath[] )
{
	AddToStringTable( FindStringTable( "soundprecache" ), szPath );
}

stock Client_SetAssists(client, value)
{
	new assists_offset = FindDataMapOffs( client, "m_iFrags" ) + ASSISTS_OFFSET_FROM_FRAGS; 
	SetEntData(client, assists_offset, value );
}

public SetStandingStartButton(client)
{	
	CreateButton(client,"climb_startbutton");
}


public SetStandingStopButton(client)
{
	CreateButton(client,"climb_endbutton");
}

public Action:BlockRadio(client, const String:command[], args) 
{
	if(!g_bRadioCommands)
	{
		PrintToChat(client, "%t", "RadioCommandsDisabled", LIMEGREEN,WHITE);
		return Plugin_Handled;
	}
	return Plugin_Continue;
}

public StringToUpper(String:input[]) 
{
	for(new i = 0; ; i++) 
	{
		if(input[i] == '\0') 
			return;
		input[i] = CharToUpper(input[i]);
	}
}

public GetCountry(client)
{
	if(client != 0)
	{
		if(!IsFakeClient(client))
		{
			new String:IP[16];
			decl String:code2[3];
			GetClientIP(client, IP, 16);
			
			//COUNTRY
			GeoipCountry(IP, g_szCountry[client], 100);     
			if(!strcmp(g_szCountry[client], NULL_STRING))
				Format( g_szCountry[client], 100, "Unknown", g_szCountry[client] );
			else				
				if( StrContains( g_szCountry[client], "United", false ) != -1 || 
					StrContains( g_szCountry[client], "Republic", false ) != -1 || 
					StrContains( g_szCountry[client], "Federation", false ) != -1 || 
					StrContains( g_szCountry[client], "Island", false ) != -1 || 
					StrContains( g_szCountry[client], "Netherlands", false ) != -1 || 
					StrContains( g_szCountry[client], "Isle", false ) != -1 || 
					StrContains( g_szCountry[client], "Bahamas", false ) != -1 || 
					StrContains( g_szCountry[client], "Maldives", false ) != -1 || 
					StrContains( g_szCountry[client], "Philippines", false ) != -1 || 
					StrContains( g_szCountry[client], "Vatican", false ) != -1 )
				{
					Format( g_szCountry[client], 100, "The %s", g_szCountry[client] );
				}				
			//CODE
			if(GeoipCode2(IP, code2))
			{
				Format(g_szCountryCode[client], 16, "%s",code2);		
			}
			else
				Format(g_szCountryCode[client], 16, "??");	
		}
	}
}

public StripWeapons(client) 
{
	new weapons;
	for (new i = 0; i < 4; i++)
	{
		if (i < 4 && (weapons = GetPlayerWeaponSlot(client, i)) != -1 && (weapons = GetPlayerWeaponSlot(client, i)) != 2) 
		{
			RemovePlayerItem(client, weapons);	
		}
		GivePlayerItem(client, "weapon_knife");	
	}
	if (IsFakeClient(client))
		GivePlayerItem(client, "weapon_usp_silencer");		
}

public DeleteButtons(client)
{
	new String:classname[32];
	Format(classname,32,"prop_physics_override");
	for (new i; i < GetEntityCount(); i++)
    {
        if (IsValidEdict(i) && GetEntityClassname(i, classname, 32))
		{
			decl String:targetname[64];
			GetEntPropString(i, Prop_Data, "m_iName", targetname, sizeof(targetname));
			if (StrEqual(targetname, "climb_startbutton", false) || StrEqual(targetname, "climb_endbutton", false))
			{
				AcceptEntityInput(i, "Kill"); 
				RemoveEdict(i);
			}
		}	
	}
	Format(classname,32,"env_sprite");
	for (new i; i < GetEntityCount(); i++)
	{
        if (IsValidEdict(i) && GetEntityClassname(i, classname, 32))
		{
			decl String:targetname[64];
			GetEntPropString(i, Prop_Data, "m_iName", targetname, sizeof(targetname));
			if (StrEqual(targetname, "starttimersign", false) || StrEqual(targetname, "stoptimersign", false))
			{
				AcceptEntityInput(i, "Kill");
				RemoveEdict(i);
			}
		}
	}
	g_bMapButtons = false;
	KzAdminMenu(client);
}

public CreateButton(client,String:targetname[]) 
{
	if (IsPlayerAlive(client))
	{
		//location (crosshair)
		new Float:locationPlayer[3];
		new Float:location[3];
		GetClientAbsOrigin(client, locationPlayer);
		GetClientEyePosition(client, location);
		new Float:ang[3];
		GetClientEyeAngles(client, ang);
		new Float:location2[3];
		location2[0] = (location[0]+(100*((Cosine(DegToRad(ang[1]))) * (Cosine(DegToRad(ang[0]))))));
		location2[1] = (location[1]+(100*((Sine(DegToRad(ang[1]))) * (Cosine(DegToRad(ang[0]))))));
		ang[0] -= (2*ang[0]);
		location2[2] = (location[2]+(100*(Sine(DegToRad(ang[0])))));
		location2[2] = locationPlayer[2];
	
		new ent = CreateEntityByName("prop_physics_override");
		if (ent != -1)
		{  
			DispatchKeyValue(ent, "model", "models/props/switch001.mdl");	
			DispatchKeyValue(ent, "spawnflags", "264");
			DispatchKeyValue(ent, "targetname",targetname);
			DispatchSpawn(ent);  
			ang[0] = 0.0;
			ang[1] += 180.0;
			TeleportEntity(ent, location2, ang, NULL_VECTOR);
			SDKHook(ent, SDKHook_UsePost, OnUsePost);				
			PrintToChat(client,"%c[%cKZ%c] %s created", WHITE,MOSSGREEN,WHITE,targetname);
			g_bMapButtons=true;
			ang[1] -= 180.0;
		}
		new sprite = CreateEntityByName("env_sprite");
		if(sprite != -1) 
		{ 
			DispatchKeyValue(sprite, "classname", "env_sprite");
			DispatchKeyValue(sprite, "spawnflags", "1");
			DispatchKeyValue(sprite, "scale", "0.2");
			if (StrEqual(targetname, "climb_startbutton"))
			{
				DispatchKeyValue(sprite, "model", "materials/models/props/startkztimer.vmt"); 
				DispatchKeyValue(sprite, "targetname", "starttimersign");
			}
			else
			{
				DispatchKeyValue(sprite, "model", "materials/models/props/stopkztimer.vmt"); 
				DispatchKeyValue(sprite, "targetname", "stoptimersign");
			}
			DispatchKeyValue(sprite, "rendermode", "1");
			DispatchKeyValue(sprite, "framerate", "0");
			DispatchKeyValue(sprite, "HDRColorScale", "1.0");
			DispatchKeyValue(sprite, "rendercolor", "255 255 255");
			DispatchKeyValue(sprite, "renderamt", "255");
			DispatchSpawn(sprite);
			location = location2;	
			location[2]+=95;
			ang[0] = 0.0;
			TeleportEntity(sprite, location, ang, NULL_VECTOR);
		}
		
		if (StrEqual(targetname, "climb_startbutton"))
			db_updateMapButtons(location2[0],location2[1],location2[2],ang[1],0);
		else
			db_updateMapButtons(location2[0],location2[1],location2[2],ang[1],1);
	}
	else
		PrintToChat(client, "%t", "AdminSetButton", MOSSGREEN,WHITE); 
	KzAdminMenu(client);
}

// - Get Runtime -
public GetcurrentRunTime(client)
{
	g_fRunTime[client] = GetEngineTime() - g_fStartTime[client] - g_fPauseTime[client];					
	if (g_bPause[client])
		Format(g_szMenuTitleRun[client], 255, "%s\nTimer on Hold", g_szPlayerPanelText[client]);
	else
	{
		FormatTimeFloat(client, g_fRunTime[client], 1);
		if(g_bShowTime[client])
		{		
			if(StrEqual(g_szPlayerPanelText[client],""))		
				Format(g_szMenuTitleRun[client], 255, "%s", g_szTime[client]);
			else
				Format(g_szMenuTitleRun[client], 255, "%s\n%s", g_szPlayerPanelText[client],g_szTime[client]);
		}
		else
		{
			Format(g_szMenuTitleRun[client], 255, "%s", g_szPlayerPanelText[client]);
		}
	}	
}

public Float:GetSpeed(client)
{
	decl Float:fVelocity[3];
	GetEntPropVector(client, Prop_Data, "m_vecVelocity", fVelocity);
	new Float:speed = SquareRoot(Pow(fVelocity[0],2.0)+Pow(fVelocity[1],2.0));
	return speed;
}

public Float:GetVelocity(client)
{
	decl Float:fVelocity[3];
	GetEntPropVector(client, Prop_Data, "m_vecVelocity", fVelocity);
	new Float:speed = SquareRoot(Pow(fVelocity[0],2.0)+Pow(fVelocity[1],2.0)+Pow(fVelocity[2],2.0));
	return speed;
}

public PlayLeetJumpSound(client)
{
	decl String:buffer[255];	

	//all sound
	if (g_LeetJumpDominating[client] == 3 || g_LeetJumpDominating[client] == 5)
	{
		for (new i = 1; i <= MaxClients; i++)
		{ 
			if(IsClientInGame(i) && !IsFakeClient(i) && i != client && g_bColorChat[i] && g_bEnableQuakeSounds[i])
			{	
					if (g_LeetJumpDominating[client]==3)
					{
						Format(buffer, sizeof(buffer), "play %s", LEETJUMP_RAMPAGE_RELATIVE_SOUND_PATH); 	
						ClientCommand(i, buffer); 
					}
					else
						if (g_LeetJumpDominating[client]==5)
						{
							Format(buffer, sizeof(buffer), "play %s", LEETJUMP_DOMINATING_RELATIVE_SOUND_PATH); 		
							ClientCommand(i, buffer); 
						}
			}
		}
	}
	
	//client sound
	if 	(IsClientInGame(client) && !IsFakeClient(client) && g_bEnableQuakeSounds[client])
	{
		if (g_LeetJumpDominating[client] != 3 && g_LeetJumpDominating[client] != 5)
		{
			Format(buffer, sizeof(buffer), "play %s", LEETJUMP_RELATIVE_SOUND_PATH); 
			ClientCommand(client, buffer); 
		}
			else
			if (g_LeetJumpDominating[client]==3)
			{
				Format(buffer, sizeof(buffer), "play %s", LEETJUMP_RAMPAGE_RELATIVE_SOUND_PATH); 	
				ClientCommand(client, buffer); 
			}
			else
			if (g_LeetJumpDominating[client]==5)
			{
				Format(buffer, sizeof(buffer), "play %s", LEETJUMP_DOMINATING_RELATIVE_SOUND_PATH); 		
				ClientCommand(client, buffer); 
			}					
	}
}

public SetCashState()
{
	ServerCommand("mp_startmoney 0; mp_playercashawards 0; mp_teamcashawards 0");
	for (new i = 1; i <= MaxClients; i++)
	{
		if (IsClientConnected(i) && IsClientInGame(i))
			SetEntProp(i, Prop_Send, "m_iAccount", 0);
	}
}

public PlayRecordSound(iRecordtype)
{
	decl String:buffer[255];
	if (iRecordtype==1)
	    for(new i = 1; i <= GetMaxClients(); i++) 
		{ 
			if(IsClientInGame(i) && !IsFakeClient(i) && g_bEnableQuakeSounds[i] == true) 
			{ 
				Format(buffer, sizeof(buffer), "play %s", PRO_RELATIVE_SOUND_PATH); 
				ClientCommand(i, buffer); 
			}
		} 
	else
		if (iRecordtype==2 || iRecordtype == 3)
			for(new i = 1; i <= GetMaxClients(); i++) 
			{ 
				if(IsClientInGame(i) && !IsFakeClient(i) && g_bEnableQuakeSounds[i] == true) 
				{ 
					Format(buffer, sizeof(buffer), "play %s", CP_RELATIVE_SOUND_PATH); 
					ClientCommand(i, buffer); 
				}
			}
}

public InitPrecache()
{
	AddFileToDownloadsTable( PRO_FULL_SOUND_PATH );
	FakePrecacheSound( PRO_RELATIVE_SOUND_PATH );	
	AddFileToDownloadsTable( CP_FULL_SOUND_PATH );
	FakePrecacheSound( CP_RELATIVE_SOUND_PATH );
	AddFileToDownloadsTable( PRO_FULL_SOUND_PATH );
	FakePrecacheSound( PRO_RELATIVE_SOUND_PATH );	
	AddFileToDownloadsTable( LEETJUMP_FULL_SOUND_PATH );
	FakePrecacheSound( LEETJUMP_RELATIVE_SOUND_PATH );
	AddFileToDownloadsTable( LEETJUMP_DOMINATING_FULL_SOUND_PATH );
	FakePrecacheSound( LEETJUMP_DOMINATING_RELATIVE_SOUND_PATH );
	AddFileToDownloadsTable( LEETJUMP_RAMPAGE_FULL_SOUND_PATH );
	FakePrecacheSound( LEETJUMP_RAMPAGE_RELATIVE_SOUND_PATH );
	AddFileToDownloadsTable( PROJUMP_FULL_SOUND_PATH );
	FakePrecacheSound( PROJUMP_RELATIVE_SOUND_PATH );
	AddFileToDownloadsTable("models/props/switch001.mdl");
	AddFileToDownloadsTable("models/props/switch001.vvd");
	AddFileToDownloadsTable("models/props/switch001.phy");
	AddFileToDownloadsTable("models/props/switch001.vtx");
	AddFileToDownloadsTable("models/props/switch001.dx90.vtx");		
	AddFileToDownloadsTable("materials/models/props/switch.vmt");
	AddFileToDownloadsTable("materials/models/props/switch.vtf");
	AddFileToDownloadsTable("materials/models/props/switch001.vmt");
	AddFileToDownloadsTable("materials/models/props/switch001.vtf");
	AddFileToDownloadsTable("materials/models/props/switch001_normal.vmt");
	AddFileToDownloadsTable("materials/models/props/switch001_normal.vtf");
	AddFileToDownloadsTable("materials/models/props/switch001_lightwarp.vmt");
	AddFileToDownloadsTable("materials/models/props/switch001_lightwarp.vtf");
	AddFileToDownloadsTable("materials/models/props/switch001_exponent.vmt");
	AddFileToDownloadsTable("materials/models/props/switch001_exponent.vtf");
	AddFileToDownloadsTable("materials/models/props/startkztimer.vmt");
	AddFileToDownloadsTable("materials/models/props/startkztimer.vtf");	
	AddFileToDownloadsTable("materials/models/props/stopkztimer.vmt");
	AddFileToDownloadsTable("materials/models/props/stopkztimer.vtf");
	PrecacheModel("materials/models/props/startkztimer.vmt",true);
	PrecacheModel("materials/models/props/stopkztimer.vmt",true);
	PrecacheModel("models/props/switch001.mdl",true);
	PrecacheModel(g_sReplayBotArmModel,true);
	PrecacheModel(g_sReplayBotPlayerModel,true);
	PrecacheModel(g_sArmModel,true);
	PrecacheModel(g_sPlayerModel,true);
}

// thx to V952 https://forums.alliedmods.net/showthread.php?t=212886
stock TraceClientViewEntity(client)
{
	new Float:m_vecOrigin[3];
	new Float:m_angRotation[3];
	GetClientEyePosition(client, m_vecOrigin);
	GetClientEyeAngles(client, m_angRotation);
	new Handle:tr = TR_TraceRayFilterEx(m_vecOrigin, m_angRotation, MASK_VISIBLE, RayType_Infinite, TRDontHitSelf, client);
	new pEntity = -1;
	if (TR_DidHit(tr))
	{
		pEntity = TR_GetEntityIndex(tr);
		CloseHandle(tr);
		return pEntity;
	}
	CloseHandle(tr);
	return -1;
}

// thx to V952 https://forums.alliedmods.net/showthread.php?t=212886
public bool:TRDontHitSelf(entity, mask, any:data)
{
	if (entity == data)
		return false;
	return true;
}

public PrintMapRecords(client)
{
	if (g_fRecordTimeGlobal != 9999999.0)
	{
		FormatTimeFloat(client, g_fRecordTimeGlobal, 3);
		PrintToChat(client, "[%cKZ%c] %cGLOBAL RECORD%c: %s (%s)",MOSSGREEN,WHITE,RED,WHITE, g_szTime[client], g_szRecordGlobalPlayer); 
	}	
	if (g_fRecordTimeGlobal128 != 9999999.0)
	{
		FormatTimeFloat(client, g_fRecordTimeGlobal128, 3);
		PrintToChat(client, "[%cKZ%c] %cGLOBAL RECORD (128)%c: %s (%s)",MOSSGREEN,WHITE,RED,WHITE, g_szTime[client], g_szRecordGlobalPlayer128); 
	}	
	if (g_fRecordTimePro != 9999999.0)
	{
		FormatTimeFloat(client, g_fRecordTimePro, 3);
		PrintToChat(client, "[%cKZ%c] %cPRO RECORD%c: %s (%s)",MOSSGREEN,WHITE,PURPLE,WHITE, g_szTime[client], g_szRecordPlayerPro); 
	}	
	if (g_fRecordTime != 9999999.0)
	{
		FormatTimeFloat(client, g_fRecordTime, 3);
		PrintToChat(client, "[%cKZ%c] %cTP RECORD%c: %s (%s)",MOSSGREEN,WHITE,YELLOW,WHITE, g_szTime[client], g_szRecordPlayer); 
	}	
}

public MapFinishedMsgs(client, type)
{	
	if (IsClientConnected(client))
	{
		
		decl String:szName[MAX_NAME_LENGTH];
		GetClientName(client, szName, MAX_NAME_LENGTH);
		new count;
		new rank;
		if (type==1)
		{
			count = g_maptimes_pro;
			rank = g_maprank_pro[client];
			FormatTimeFloat(client, g_fRecordTimePro, 3);	
		}
		else
		if (type==0)
		{
			count = g_maptimes_tp;
			rank = g_maprank_tp[client];		
			FormatTimeFloat(client, g_fRecordTime, 3);	
		}
		for(new i = 1; i <= GetMaxClients(); i++) 
		if(IsClientInGame(i) && !IsFakeClient(i)) 
		{
			if (g_time_type[client] == 0)
			{
				PrintToChat(i, "%t", "MapFinished0",MOSSGREEN,WHITE,LIMEGREEN,szName,GRAY,LIMEGREEN, g_szNewTime[client],GRAY,LIMEGREEN,g_OverallTp[client],GRAY, WHITE, LIMEGREEN, rank, WHITE,count,LIMEGREEN,g_szTime[client],WHITE); 
				PrintToConsole(i, "%s finished with a tp time of (%s, TP's: %i). [rank #%i/%i | record %s]",szName,g_szNewTime[client],g_OverallTp[client],rank,count,g_szTime[client]); 
			}
			else
			if (g_time_type[client] == 1)
			{
				PrintToChat(i, "%t", "MapFinished1",MOSSGREEN,WHITE,LIMEGREEN,szName,GRAY,LIMEGREEN, g_szNewTime[client],GRAY, WHITE, LIMEGREEN, rank, WHITE,count,LIMEGREEN,g_szTime[client],WHITE); 
				PrintToConsole(i, "%s finished with a pro time of (%s). [rank #%i/%i | record %s]",szName,g_szNewTime[client],rank,count,g_szTime[client]);  
			}			
			else
				if (g_time_type[client] == 2)
				{
					PrintToChat(i, "%t", "MapFinished2",MOSSGREEN,WHITE,LIMEGREEN,szName,GRAY,LIMEGREEN, g_szNewTime[client],GRAY,LIMEGREEN,g_OverallTp[client],GRAY,GREEN, g_szTimeDifference[client],GRAY, WHITE, LIMEGREEN, rank, WHITE,count,LIMEGREEN,g_szTime[client],WHITE);  				
					PrintToConsole(i, "%s finished with a tp time of (%s, TP's: %i). Improving their best time by (%s).  [rank #%i/%i | record %s]",szName,g_szNewTime[client],g_OverallTp[client],g_szTimeDifference[client],rank,count,g_szTime[client]);  
				}
				else
					if (g_time_type[client] == 3)
					{
						PrintToChat(i, "%t", "MapFinished3",MOSSGREEN,WHITE,LIMEGREEN,szName,GRAY,LIMEGREEN, g_szNewTime[client],GRAY,GREEN, g_szTimeDifference[client],GRAY, WHITE, LIMEGREEN, rank, WHITE,count,LIMEGREEN,g_szTime[client],WHITE);  				
						PrintToConsole(i, "%s finished with a pro time of (%s). Improving their best time by (%s).  [rank #%i/%i | record %s]",szName,g_szNewTime[client],g_szTimeDifference[client],rank,count,g_szTime[client]); 	
					}
					else
						if (g_time_type[client] == 4)
						{
							PrintToChat(i, "%t", "MapFinished4",MOSSGREEN,WHITE,LIMEGREEN,szName,GRAY,LIMEGREEN, g_szNewTime[client],GRAY,LIMEGREEN,g_OverallTp[client],GRAY,RED, g_szTimeDifference[client],GRAY, WHITE, LIMEGREEN, rank, WHITE,count,LIMEGREEN,g_szTime[client],WHITE);  	
							PrintToConsole(i, "%s finished with a tp time of (%s, TP's: %i). Missing their best time by (%s).  [rank #%i/%i | record %s]",szName,g_szNewTime[client],g_OverallTp[client],g_szTimeDifference[client],rank,count,g_szTime[client]); 
						}
						else
							if (g_time_type[client] == 5)
							{
								PrintToChat(i, "%t", "MapFinished5",MOSSGREEN,WHITE,LIMEGREEN,szName,GRAY,LIMEGREEN, g_szNewTime[client],GRAY,RED, g_szTimeDifference[client],GRAY, WHITE, LIMEGREEN, rank, WHITE,count,LIMEGREEN,g_szTime[client],WHITE);  	
								PrintToConsole(i, "%s finished with a pro time of (%s). Missing their best time by (%s).  [rank #%i/%i | record %s]",szName,g_szNewTime[client],g_szTimeDifference[client],rank,count,g_szTime[client]); 
							}
			//new record msg
			if (g_record_type[client] == 4)				
			{
				PrintToChat(i, "%t", "NewGlobalRecord128",MOSSGREEN,WHITE,LIMEGREEN,szName,GRAY,RED); 	
				PrintToConsole(i, "[KZ] %s scored a new GLOBAL RECORD (128)",szName); 		
			}
			else
				if (g_record_type[client] == 3)				
				{
					PrintToChat(i, "%t", "NewGlobalRecord",MOSSGREEN,WHITE,LIMEGREEN,szName,GRAY,RED); 	
					PrintToConsole(i, "[KZ] %s scored a new GLOBAL RECORD",szName); 		
				}
				else
					if (g_record_type[client] == 2)				
					{
						PrintToChat(i, "%t", "NewProRecord",MOSSGREEN,WHITE,LIMEGREEN,szName,GRAY,PURPLE);  
						PrintToConsole(i, "[KZ] %s scored a new PRO RECORD",szName); 	
					}		
					else
						if (g_record_type[client] == 1)				
						{
							PrintToChat(i, "%t", "NewTpRecord",MOSSGREEN,WHITE,LIMEGREEN,szName,GRAY,YELLOW); 	
							PrintToConsole(i, "[KZ] %s scored a new TP RECORD",szName); 	
						}					
		}
		if (rank==99999)
			PrintToChat(client, "[%cKZ%c] %cFailed to save your data correctly! There might be a problem with your player name. ( e.g. special characters like %c'%c )",MOSSGREEN,WHITE,DARKRED,RED,DARKRED); 	
		//Sound
		PlayRecordSound(g_sound_type[client]);			
	
		//noclip MsgMsg
		if (g_bMapFinished[client] == false && !StrEqual(g_pr_rankname[client],"MASTER") && g_bNoClipS)
			PrintToChat(client, "%t", "NoClipUnlocked",MOSSGREEN,WHITE,YELLOW);
		g_bMapFinished[client] = true;
		CreateTimer(2.0, DBUpdateTimer, client,TIMER_FLAG_NO_MAPCHANGE);
		g_fStartTime[client] = -1.0;		
	}
}

public FormatTimeFloat(client, Float:time, type)
{
	decl String:szMilli[16];
	decl String:szSeconds[16];
	decl String:szMinutes[16];
	decl String:szHours[16];
	new imilli;
	new iseconds;
	new iminutes;
	new ihours;
	time = FloatAbs(time);
	imilli = RoundToZero(time*100);
	imilli = imilli%100;
	iseconds = RoundToZero(time);
	iseconds = iseconds%60;	
	iminutes = RoundToZero(time/60);	
	iminutes = iminutes%60;	
	ihours = RoundToZero((time/60)/60);

	if (imilli < 10)
		Format(szMilli, 16, "0%dms", imilli);
	else
		Format(szMilli, 16, "%dms", imilli);
	if (iseconds < 10)
		Format(szSeconds, 16, "0%ds", iseconds);
	else
		Format(szSeconds, 16, "%ds", iseconds);
	if (iminutes < 10)
		Format(szMinutes, 16, "0%dm", iminutes);
	else
		Format(szMinutes, 16, "%dm", iminutes);	
	if (type==1)
	{
		Format(szHours, 16, "%dm", iminutes);	
		if (ihours>0)	
		{
			Format(szHours, 16, "%dh", ihours);
			Format(g_szTime[client], 32, "%s %s %s %s", szHours, szMinutes,szSeconds,szMilli);
		}
		else
			Format(g_szTime[client], 32, "%s %s %s", szMinutes,szSeconds,szMilli);	
	}
	else
	if (type==2)
	{
		imilli = RoundToZero(time*1000);
		imilli = imilli%1000;
		if (imilli < 10)
			Format(szMilli, 16, "00%dms", imilli);
		else
		if (imilli < 100)
			Format(szMilli, 16, "0%dms", imilli);
		else
			Format(szMilli, 16, "%dms", imilli);
		Format(szHours, 16, "%dh", ihours);
		Format(g_szTime[client], 32, "%s %s %s %s",szHours, szMinutes,szSeconds,szMilli);
	}
	else
	if (type==3)
	{
		if (imilli < 10)
			Format(szMilli, 16, "0%d", imilli);
		else
			Format(szMilli, 16, "%d", imilli);
		if (iseconds < 10)
			Format(szSeconds, 16, "0%d", iseconds);
		else
			Format(szSeconds, 16, "%d", iseconds);
		if (iminutes < 10)
			Format(szMinutes, 16, "0%d", iminutes);
		else
			Format(szMinutes, 16, "%d", iminutes);	
		if (ihours>0)	
		{
			Format(szHours, 16, "%d", ihours);
			Format(g_szTime[client], 32, "%s:%s:%s.%s", szHours, szMinutes,szSeconds,szMilli);
		}
		else
			Format(g_szTime[client], 32, "%s:%s.%s", szMinutes,szSeconds,szMilli);	
	}
	if (type==4)
	{
		if (imilli < 10)
			Format(szMilli, 16, "0%d", imilli);
		else
			Format(szMilli, 16, "%d", imilli);
		if (iseconds < 10)
			Format(szSeconds, 16, "0%d", iseconds);
		else
			Format(szSeconds, 16, "%d", iseconds);
		if (iminutes < 10)
			Format(szMinutes, 16, "0%d", iminutes);
		else
			Format(szMinutes, 16, "%d", iminutes);	
		if (ihours>0)	
		{
			Format(szHours, 16, "%d", ihours);
			Format(g_szTime[client], 32, "%s:%s:%s", szHours, szMinutes,szSeconds);
		}
		else
			Format(g_szTime[client], 32, "%s:%s", szMinutes,szSeconds);	
	}
}

public SetPlayerRank(client)
{
	if (g_pr_points[client] < g_pr_rank_Novice)
		Format(g_pr_rankname[client], 32, "NEWBIE");
	else					
	if (g_pr_rank_Novice <= g_pr_points[client] && g_pr_points[client] < g_pr_rank_Scrub)
		Format(g_pr_rankname[client], 32, "NOVICE");
	else
	if (g_pr_rank_Scrub <= g_pr_points[client] && g_pr_points[client] < g_pr_rank_Rookie)
		Format(g_pr_rankname[client], 32, "SCRUB");
	else
	if (g_pr_rank_Rookie <= g_pr_points[client] && g_pr_points[client] < g_pr_rank_Skilled)
		Format(g_pr_rankname[client], 32, "ROOKIE");
	else
	if (g_pr_rank_Skilled <= g_pr_points[client] && g_pr_points[client] < g_pr_rank_Expert)
		Format(g_pr_rankname[client], 32, "SKILLED");
	else
	if (g_pr_rank_Expert <= g_pr_points[client] && g_pr_points[client] < g_pr_rank_Pro)
		Format(g_pr_rankname[client], 32, "EXPERT");
	else
	if (g_pr_rank_Pro <= g_pr_points[client] && g_pr_points[client] < g_pr_rank_Elite)
		Format(g_pr_rankname[client], 32, "PRO");
	else
	if (g_pr_rank_Elite <= g_pr_points[client] && g_pr_points[client] < g_pr_rank_Master)
		Format(g_pr_rankname[client], 32, "ELITE");		
	else
	if (g_pr_points[client] >= g_pr_rank_Master)
		Format(g_pr_rankname[client], 32, "MASTER");	
}

stock Action:PrintSpecMessageAll(client)
{
	decl String:szName[MAX_NAME_LENGTH];
	GetClientName(client, szName, sizeof(szName));
	decl String:szTextToAll[1024];
	GetCmdArgString(szTextToAll, sizeof(szTextToAll));
	StripQuotes(szTextToAll);
	if (StrEqual(szTextToAll,"") || StrEqual(szTextToAll," ") || StrEqual(szTextToAll,"  "))
		return Plugin_Handled;
		
	if (g_bCountry && g_bPointSystem)	
		CPrintToChatAll("%c%s%c [%c%s%c] *SPEC* %c%s%c: %s", GREEN,g_szCountryCode[client],WHITE,GRAY,g_pr_rankname[client],WHITE,GRAY,szName,WHITE, szTextToAll);
	else
		if (g_bPointSystem)	
			CPrintToChatAll("[%c%s%c] *SPEC* %c%s%c: %s", GRAY,g_pr_rankname[client],WHITE,GRAY,szName,WHITE, szTextToAll);
		else
			if (g_bCountry)
				CPrintToChatAll("[%c%s%c] *SPEC* %c%s%c: %s", GREEN,g_szCountryCode[client],WHITE,GRAY,szName,WHITE, szTextToAll);
			else		
				CPrintToChatAll("*SPEC* %c%s%c: %s", GRAY,szName,WHITE, szTextToAll);
	for (new i = 1; i <= MaxClients; i++)
		if (1 <= i <= MaxClients && IsClientInGame(i) && IsValidEntity(i))	
		{
			if (g_bCountry && g_bPointSystem)
				PrintToConsole(i, "%s [%s] *SPEC* %s: %s", g_szCountryCode[client],g_pr_rankname[client],szName, szTextToAll);
			else	
				if (g_bCountry)
				PrintToConsole(i, "[%s] *SPEC* %s: %s", g_szCountryCode[client],szName, szTextToAll);		
				else
					if (g_bPointSystem)
						PrintToConsole(i, "[%s] *SPEC* %s: %s", g_pr_rankname[client],szName, szTextToAll);	
						else
							PrintToConsole(i, "*SPEC* %s: %s", szName, szTextToAll);
		}
	return Plugin_Handled;
}

//http://pastebin.com/YdUWS93H
public bool:CheatFlag(const String:voice_inputfromfile[], bool:isCommand, bool:remove)
{
	if(remove)
	{
		if (!isCommand)
		{
			new Handle:hConVar = FindConVar(voice_inputfromfile);
			if (hConVar != INVALID_HANDLE)
			{
				new flags = GetConVarFlags(hConVar);
				SetConVarFlags(hConVar, flags &= ~FCVAR_CHEAT);
				return true;
			} 
			else 
				return false;			
		} 
		else 
		{
			new flags = GetCommandFlags(voice_inputfromfile);
			if (SetCommandFlags(voice_inputfromfile, flags &= ~FCVAR_CHEAT))
				return true;
			else 
				return false;
		}
	}
	else
	{
		if (!isCommand)
		{
			new Handle:hConVar = FindConVar(voice_inputfromfile);
			if (hConVar != INVALID_HANDLE)
			{
				new flags = GetConVarFlags(hConVar);
				SetConVarFlags(hConVar, flags & FCVAR_CHEAT);
				return true;
			}
			else 
				return false;
			
			
		} else
		{
			new flags = GetCommandFlags(voice_inputfromfile);
			if (SetCommandFlags(voice_inputfromfile, flags & FCVAR_CHEAT))	
				return true;
			else 
				return false;
				
		}
	}
}

public PlayerPanel(client)
{	
	if (!IsClientInGame(client) || !IsPlayerAlive(client) || g_bTopMenuOpen[client] || IsFakeClient(client))
		return;

	if (GetClientMenu(client) == MenuSource_None)
	{
		g_bMenuOpen[client] = false;
		g_bClimbersMenuOpen[client] = false;		
	}	
	if (g_bMenuOpen[client] || g_bClimbersMenuOpen[client]) 
		return;	
	if (g_bTimeractivated[client])
	{
		GetcurrentRunTime(client);
		if(!StrEqual(g_szMenuTitleRun[client],""))		
		{
			new Handle:panel = CreatePanel();
			DrawPanelText(panel, g_szMenuTitleRun[client]);
			SendPanelToClient(panel, client, PanelHandler, 1);
			CloseHandle(panel);
		}
	}
	else
	{
		new String:szTmp[255];
		new Handle:panel = CreatePanel();				
		if(!StrEqual(g_szPlayerPanelText[client],""))
			Format(szTmp, 255, "%s\nSpeed: %.1f u/s",g_szPlayerPanelText[client],GetSpeed(client));
		else
			Format(szTmp, 255, "Speed: %.1f u/s",GetSpeed(client));
		
		DrawPanelText(panel, szTmp);
		SendPanelToClient(panel, client, PanelHandler, 1);
		CloseHandle(panel);
		
	}
}

public SpecList(client)
{
	if (!IsClientInGame(client) || g_bTopMenuOpen[client]  || IsFakeClient(client))
		return;
		
	if (GetClientMenu(client) == MenuSource_None)
	{
		g_bMenuOpen[client] = false;
		g_bClimbersMenuOpen[client] = false;		
	}
	if (g_bTimeractivated[client] && !g_bSpectate[client]) 
		return; 
	if (g_bMenuOpen[client] || g_bClimbersMenuOpen[client]) 
		return;
	if(!StrEqual(g_szPlayerPanelText[client],""))
	{
		new Handle:panel = CreatePanel();
		DrawPanelText(panel, g_szPlayerPanelText[client]);
		SendPanelToClient(panel, client, PanelHandler, 1);
		CloseHandle(panel);
	}
}

public PanelHandler(Handle:menu, MenuAction:action, param1, param2)
{
}

public bool:TraceRayDontHitSelf(entity, mask, any:data) 
{
	return (entity != data);
}

stock bool:IntoBool(status)
{
	if(status > 0)
		return true;
	else
		return false;
}

stock BooltoInt(bool:status)
{
	if(status)
		return 1;
	else
		return 0;
}

public PlayQuakeSound_Spec(client, String:buffer[255])
{
	new SpecMode;
	for(new x = 1; x <= MaxClients; x++) 
	{
		if (IsClientInGame(x) && !IsPlayerAlive(x))
		{			
			SpecMode = GetEntProp(x, Prop_Send, "m_iObserverMode");
			if (SpecMode == 4 || SpecMode == 5)
			{		
				new Target = GetEntPropEnt(x, Prop_Send, "m_hObserverTarget");	
				if (Target == client)
					if (g_bEnableQuakeSounds[x] && g_bColorChat[x])
						ClientCommand(x, buffer); 
			}					
		}		
	}
}

public PerformBan(client)
{
	if (IsValidEntity(client) && IsClientInGame(client))
	{
		decl String:szSteamID[32];
		decl String:szName[64];
		GetClientAuthString(client,szSteamID,32);
		GetClientName(client,szName,64);
		if (g_hDbGlobal != INVALID_HANDLE)
			db_InsertBan(szSteamID, szName);
		new bantime= RoundToZero(g_fBanDuration*60);
		decl String:banmsg[255];
		Format(banmsg, sizeof(banmsg), "KZ AntiCheat: You were banned for using a BhopHack (%.0fh)",g_fBanDuration); 
		BanClient(client, bantime, BANFLAG_AUTO, banmsg, banmsg);
		db_DeleteCheater(client,szSteamID);
	}
}

public GiveUsp(client)
{
	if(!IsPlayerAlive(client) || GetClientTeam(client) == 1)
		return;		
	g_UspDrops[client]++;
	GivePlayerItem(client, "weapon_usp_silencer");
	if (!g_bPreStrafe)
		PrintToChat(client, "%t", "Usp1", MOSSGREEN,WHITE);
	PrintToChat(client, "%t", "Usp2", MOSSGREEN,WHITE);
}
							
//MACRODOX BHOP PROTECTION
//https://forums.alliedmods.net/showthread.php?p=1678026
public PerformStats(client, target)
{
	new String:banstats[256];
	GetClientStats(target, banstats, sizeof(banstats));
	PrintToChat(client, "[%cKZ%c] %s",MOSSGREEN,WHITE,banstats);
	PrintToConsole(client, "[KZ] %s",banstats);
}

//MACRODOX BHOP PROTECTION
//https://forums.alliedmods.net/showthread.php?p=1678026
public GetClientStats(client, String:string[], length)
{
	new String:map[128];
	new String:szName[64];
	GetClientName(client,szName,64);
	GetCurrentMap(map, 128);
	Format(string, length, "%cPlayer%c: %s - %cLast bhops%c: %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i",
	LIMEGREEN,
	WHITE,
	szName,
	LIMEGREEN,
	WHITE,
    aaiLastJumps[client][0],
    aaiLastJumps[client][1],
    aaiLastJumps[client][2],
    aaiLastJumps[client][3],
    aaiLastJumps[client][4],
    aaiLastJumps[client][5],
    aaiLastJumps[client][6],
    aaiLastJumps[client][7],
    aaiLastJumps[client][8],
    aaiLastJumps[client][9],
    aaiLastJumps[client][10],
    aaiLastJumps[client][11],
    aaiLastJumps[client][12],
    aaiLastJumps[client][13],
    aaiLastJumps[client][14],
    aaiLastJumps[client][15],
    aaiLastJumps[client][16],
    aaiLastJumps[client][17],
    aaiLastJumps[client][18],
    aaiLastJumps[client][19],
    aaiLastJumps[client][20],
    aaiLastJumps[client][21],
    aaiLastJumps[client][22],
    aaiLastJumps[client][23],
    aaiLastJumps[client][24],
    aaiLastJumps[client][25],
    aaiLastJumps[client][26],
    aaiLastJumps[client][27],
    aaiLastJumps[client][28],
    aaiLastJumps[client][29]);
}