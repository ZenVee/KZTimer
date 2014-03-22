// - PlayerSpawn -
public Action:Event_OnPlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	if(client != 0 && (GetClientTeam(client) > 1))
	{	
		g_bTouchWall[client] = false;
		g_fStartCommandUsed_LastTime[client] = GetEngineTime();
		g_bPlayerJumped[client] = false;
		g_SpecTarget[client] = -1;	
		g_bOnGround[client] = true;
		
		//remove weapons
		if (g_bCleanWeapons)
			StripWeapons(client);
			
		//godmode
		if (g_bgodmode || IsFakeClient(client))
			SetEntProp(client, Prop_Data, "m_takedamage", 0, 1);
		else
			SetEntProp(client, Prop_Data, "m_takedamage", 2, 1);
			
		//NoBlock
		if(g_bNoBlock || IsFakeClient(client))
			SetEntData(client, FindSendPropOffs("CBaseEntity", "m_CollisionGroup"), 2, 4, true);
		else
			SetEntData(client, FindSendPropOffs("CBaseEntity", "m_CollisionGroup"), 5, 4, true);
				
			
		//botmimic2		
		if(g_hBotMimicsRecord[client] != INVALID_HANDLE && IsFakeClient(client))
		{
			g_iBotMimicTick[client] = 0;
			g_iCurrentAdditionalTeleportIndex[client] = 0;
		}	
		
		if (IsFakeClient(client))	
		{
			//clantag
			CS_SetClientClanTag(client, "LOCALHOST"); 
			return;
		}
		//fps Check
		if (g_bfpsCheck)
			QueryClientConVar(client, "fps_max", ConVarQueryFinished:FPSCheck, client);		
		
		//player skin
		if (g_bPlayerSkinChange)
		{
			SetEntPropString(client, Prop_Send, "m_szArmsModel", g_sArmModel);
			SetEntityModel(client,  g_sPlayerModel);
		}		
		
		//1st spawn?
		if (g_bFirstSpawn[client])		
		{
			StartRecording(client);
			CreateTimer(0.25, OnPlayerConnectTimer, client,TIMER_FLAG_NO_MAPCHANGE);
			CreateTimer(5.0, WelcomeMsgTimer, client,TIMER_FLAG_NO_MAPCHANGE);
			CreateTimer(60.0, HelpMsgTimer, client,TIMER_FLAG_NO_MAPCHANGE);
			CreateTimer(300.0, ChallengeMsgTimer, client,TIMER_FLAG_NO_MAPCHANGE);		
			g_bFirstSpawn[client] = false;
		}

		//get start pos for challenge
		GetClientAbsOrigin(client, g_fCStartPosition[client]);
		
		//restore position (before spec or last session)
		if (g_bRestoreC[client])
		{
			TeleportEntity(client, g_fPlayerCordsRestore[client],g_fPlayerAnglesRestore[client],NULL_VECTOR);
			g_bRestoreC[client]  = false;
		}
		else
			if (g_bRespawnPosition[client])
			{
				TeleportEntity(client, g_fPlayerCordsRestore[client],g_fPlayerAnglesRestore[client],NULL_VECTOR);
				g_bRespawnPosition[client] = false;
			}		
			else
				if (g_bAutoTimer)
					CL_OnStartTimerPress(client);
		
		//hide radar
		CreateTimer(0.0, HideRadar, client,TIMER_FLAG_NO_MAPCHANGE);
		
		//set clantag
		CreateTimer(1.5, SetClanTag, client,TIMER_FLAG_NO_MAPCHANGE);	
		
		//set speclist
		Format(g_szPlayerPanelText[client], 512, "");		

		if (g_bClimbersMenuOpen2[client])
		{
			g_bClimbersMenuOpen2[client] = false;
			ClimbersMenu(client);
		}				
					
		//get start pos for jumpstats
		GetClientAbsOrigin(client, g_fPosOld[client]);
			
		//get view angle
		new Float: angle[3];
		GetClientAbsAngles(client, angle);
		g_OldAngle[client] = angle[1];	
	}
}
			
public Action:Say_Hook(client, args)
{
	if (client && IsValidEntity(client) && IsClientInGame(client))
	{
		decl String:sText[1024];
		GetCmdArgString(sText, sizeof(sText));
		StripQuotes(sText);
				
		for(new i; i < sizeof(BlockedChatText); i++)
		{
			if (StrEqual(BlockedChatText[i],sText,true))
				return Plugin_Handled;
		}	
		new team = GetClientTeam(client);

		if (StrEqual("timeleft",sText,true))
		{
			new timeleft;
			GetMapTimeLeft(timeleft);
			new Float:ftime = float(timeleft);
			FormatTimeFloat(client,ftime,4);
			PrintToChat(client,"[%cKZ%c] Timeleft: %s",MOSSGREEN,WHITE, g_szTime[client]);
			return Plugin_Handled;
		}	
		
		if (StrEqual("nextmap",sText,true))
		{
			decl String:NextMap[64];
			GetNextMap(NextMap, sizeof(NextMap));
			PrintToChat(client,"[%cKZ%c] Nextmap: %s",MOSSGREEN,WHITE, NextMap);
			return Plugin_Handled;
		}
		//SPEC
		if (team==1)
		{
			PrintSpecMessageAll(client);
			return Plugin_Handled;
		}
		else
		{
			if (g_bCountry && g_bPointSystem)
			{						
				if (StrEqual(sText,""))
					return Plugin_Handled;
				decl String:szName[32];
				GetClientName(client,szName,32);
				if (IsPlayerAlive(client))
				{
					if (team==CS_TEAM_T)
					{
						CPrintToChatAll("%c%s%c [%c%s%c] {orange}%s%c: %s",GREEN,g_szCountryCode[client],WHITE,GRAY,g_pr_rankname[client],WHITE,szName,WHITE,sText);
						PrintToConsole(client,"%s [%s] %s: %s",g_szCountryCode[client],g_pr_rankname[client],szName,sText);
					}
					else
						CPrintToChatAll("%c%s%c [%c%s%c] {blue}%s%c: %s",GREEN,g_szCountryCode[client],WHITE,GRAY,g_pr_rankname[client],WHITE,szName,WHITE,sText);
				}
				else
				{
					if (team==CS_TEAM_T)
					{
						CPrintToChatAll("%c%s%c [%c%s%c] {orange}*DEAD* %s%c: %s",GREEN,g_szCountryCode[client],WHITE,GRAY,g_pr_rankname[client],WHITE,szName,WHITE,sText);
						PrintToConsole(client,"%s [%s] *DEAD* %s: %s",g_szCountryCode[client],g_pr_rankname[client],szName,sText);
					}
					else
						CPrintToChatAll("%c%s%c [%c%s%c] {blue}*DEAD* %s%c: %s",GREEN,g_szCountryCode[client],WHITE,GRAY,g_pr_rankname[client],WHITE,szName,WHITE,sText);			
				}			
				return Plugin_Handled;
			}
			else
			{
				if (g_bPointSystem)
				{
					if (StrEqual(sText,""))
						return Plugin_Handled;
					decl String:szName[32];
					GetClientName(client,szName,32);
					if (IsPlayerAlive(client))
					{
						if (team==CS_TEAM_T)
						{
							CPrintToChatAll("[%c%s%c] {orange}%s%c: %s",GRAY,g_pr_rankname[client],WHITE,szName,WHITE,sText);
							PrintToConsole(client,"[%s] %s: %s",g_pr_rankname[client],szName,sText);
						}
						else
							CPrintToChatAll("[%c%s%c] {blue}%s%c: %s",GRAY,g_pr_rankname[client],WHITE,szName,WHITE,sText);
					}
					else
					{
						if (team==CS_TEAM_T)
						{
							CPrintToChatAll("[%c%s%c] {orange}*DEAD* %s%c: %s",GRAY,g_pr_rankname[client],WHITE,szName,WHITE,sText);
							PrintToConsole(client,"[%s] *DEAD* %s: %s",g_pr_rankname[client],szName,sText);
						}
						else
							CPrintToChatAll("[%c%s%c] {blue}*DEAD* %s%c: %s",GRAY,g_pr_rankname[client],WHITE,szName,WHITE,sText);			
					}			
					return Plugin_Handled;							
				}
				else
					if (g_bCountry)
					{
						if (StrEqual(sText,""))
							return Plugin_Handled;
						decl String:szName[32];
						GetClientName(client,szName,32);
						if (IsPlayerAlive(client))
						{
							if (team==CS_TEAM_T)
							{
								CPrintToChatAll("[%c%s%c] {orange}%s%c: %s",GREEN,g_szCountryCode[client],WHITE,szName,WHITE,sText);
								PrintToConsole(client,"[%s] %s: %s",g_szCountryCode[client],szName,sText);
							}
							else
								CPrintToChatAll("[%c%s%c] {blue}%s%c: %s",GREEN,g_szCountryCode[client],WHITE,szName,WHITE,sText);
						}
						else
						{
							if (team==CS_TEAM_T)
							{
								CPrintToChatAll("[%c%s%c] {orange}*DEAD* %s%c: %s",GREEN,g_szCountryCode[client],WHITE,szName,WHITE,sText);
								PrintToConsole(client,"[%s] *DEAD* %s: %s",g_szCountryCode[client],szName,sText);
							}
							else
								CPrintToChatAll("[%c%s%c] {blue}*DEAD* %s%c: %s",GREEN,g_szCountryCode[client],WHITE,szName,WHITE,sText);			
						}			
						return Plugin_Handled;							
					}			
			
			}
		}	
	}
	return Plugin_Continue;
}

public Action:EventTeamChange(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	if (!client || !IsClientInGame(client) || IsFakeClient(client))
		return;
	new team = GetEventInt(event, "team");
	if(team == 1)
	{
		//StripWeapons(client);
		GetClientAbsOrigin(client,g_fPlayerCordsRestore[client]);
		GetClientEyeAngles(client, g_fPlayerAnglesRestore[client]);
		g_bRespawnPosition[client] = true;
		if (g_bTimeractivated[client] == true)
		{	
			g_fStartPauseTime[client] = GetEngineTime();
			if (g_fPauseTime[client] > 0.0)
				g_fStartPauseTime[client] = g_fStartPauseTime[client] - g_fPauseTime[client];	
		}
		g_bSpectate[client] = true;
		PrintToChat(client, "%t", "HideSpecRadar",MOSSGREEN,WHITE,GREEN,WHITE);
		g_bPause[client]=false;
		CreateTimer(0.0, HideRadar, client,TIMER_FLAG_NO_MAPCHANGE);
	}
}

public OnMapVoteStarted()
{
   	for(new client = 1; client <= MAXPLAYERS; client++)
	{
		g_bMenuOpen[client] = true;
		if (g_bClimbersMenuOpen[client])
			g_bClimbersMenuwasOpen[client]=true;
		else
			g_bClimbersMenuwasOpen[client]=false;		
		g_bClimbersMenuOpen[client] = false;
	}
}

public Action:Hook_SetTransmit(entity, client) 
{ 
    if (client != entity && (0 < entity <= MaxClients) && IsClientInGame(client)) 
	{
		if (g_bChallenge[client])
		{
			decl String:szSteamId[32];
			GetClientAuthString(entity, szSteamId, 32);	
			if (!StrEqual(szSteamId, g_szCOpponentID[client], false))
				return Plugin_Handled;
		}
		else
			if (g_bHide[client] && entity != g_SpecTarget[client])
				return Plugin_Handled; 
	}	
    return Plugin_Continue; 
}  

// - PlayerDeath -
public Action:Event_OnPlayerDeath(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));	
	if(!client)
		return;
	if (!IsFakeClient(client))
	{
		if(g_hRecording[client] != INVALID_HANDLE)
			StopRecording(client);
		CreateTimer(0.5, OnDeathTimer, client,TIMER_FLAG_NO_MAPCHANGE);
	}
	else 
	if(g_hBotMimicsRecord[client] != INVALID_HANDLE)
	{
		g_iBotMimicTick[client] = 0;
		g_iCurrentAdditionalTeleportIndex[client] = 0;
		if(GetClientTeam(client) >= CS_TEAM_T)
			CreateTimer(1.0, Timer_DelayedRespawn, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
	}
}
					
public Action:CS_OnTerminateRound(&Float:delay, &CSRoundEndReason:reason)
{
	new timeleft;
	GetMapTimeLeft(timeleft);
	if (timeleft>= -1)
		return Plugin_Handled;
	return Plugin_Continue;
}  

// - OnRoundRestart - (restore custom Map Buttons)
public Action:Event_OnRoundStart(Handle:event, const String:name[], bool:dontBroadcast)
{
	db_selectMapButtons();
	return Plugin_Continue; 
}

// - PlayerHurt - 
public Action:Event_OnPlayerHurt(Handle:event, const String:name[], bool:dontBroadcast)
{
	if (!g_bgodmode && g_Autohealing_Hp > 0)
	{
		new client = GetClientOfUserId(GetEventInt(event, "userid"));
		new remainingHeatlh = GetEventInt(event, "health");
		if (remainingHeatlh>0)
		{
			if ((remainingHeatlh+g_Autohealing_Hp) > 100)
				SetEntData(client, FindSendPropOffs("CBasePlayer", "m_iHealth"), 100);
			else
				SetEntData(client, FindSendPropOffs("CBasePlayer", "m_iHealth"), remainingHeatlh+g_Autohealing_Hp);
		}
	}
	return Plugin_Continue; 
}

// - PlayerDamage - (if godmode 0)
public Action:OnTakeDamage(victim, &attacker, &inflictor, &Float:damage, &damagetype)
{
	if (g_bgodmode)
		return Plugin_Handled;
	return Plugin_Continue;
}


 //fpscheck
public FPSCheck(QueryCookie:cookie, client, ConVarQueryResult:result, const String:cvarName[], const String:cvarValue[])
{
	if (IsClientConnected(client) && !IsFakeClient(client))
	{
		new fps_max = StringToInt(cvarValue);        
		if (fps_max < 100 || fps_max > 300)
		{
			CreateTimer(10.0, KickPlayer, client, TIMER_FLAG_NO_MAPCHANGE);
			PrintToChat(client, "%t", "KickMsg", DARKRED,WHITE,RED,WHITE,fps_max);
		}
	}
}

//thx to TnTSCS (player slap stops timer)
//https://forums.alliedmods.net/showthread.php?t=233966
public Action:OnLogAction(Handle:source, Identity:ident, client, target, const String:message[])
{	
    if ((1 > target > MaxClients))
        return Plugin_Continue;
    if (IsValidEntity(target) && IsClientInGame(target) && IsPlayerAlive(target) && g_bTimeractivated[target] && !IsFakeClient(target))
	{
		new String:logtag[PLATFORM_MAX_PATH];
		if (ident == Identity_Plugin)
			GetPluginFilename(source, logtag, sizeof(logtag));
		else
			Format(logtag, sizeof(logtag), "OTHER");
		if ((strcmp("playercommands.smx", logtag, false) == 0) ||(strcmp("slap.smx", logtag, false) == 0))
			Client_Stop(target, 0);
	}   
    return Plugin_Continue;
}  

// OnPlayerRunCmd (Replay system, jumpstats) 
public Action:OnPlayerRunCmd(client, &buttons, &impulse, Float:vel[3], Float:angles[3], &weapon, &subtype, &cmdnum, &tickcount, &seed, mouse[2])
{
	g_CurrentButton[client] = buttons;
	if (client > 0 && IsClientInGame(client) && IsPlayerAlive(client) && !g_bSpectate[client])
	{	
	
		//glite
		//https://forums.alliedmods.net/showthread.php?t=192163
		if (g_bAutoBhop2 && g_bAutoBhopClient[client])
		{
			if (buttons & IN_JUMP)
				if (!(GetEntityFlags(client) & FL_ONGROUND))
					if (!(GetEntityMoveType(client) & MOVETYPE_LADDER))
						if (GetEntProp(client, Prop_Data, "m_nWaterLevel") <= 1)
							buttons &= ~IN_JUMP;
		}
	
		new Float:temp[3], Float:origin[3];
		GetEntPropVector(client, Prop_Data, "m_vecVelocity", temp);
		temp[2] = 0.0;
		new Float:newvelo = GetVectorLength(temp);
		GetClientAbsOrigin(client, origin);
		new Float:ang[3];
		GetClientEyeAngles(client, ang);
		if(ang[1] < 0)
			ang[1] += 360.0;
			
		///////////////////////////////////
		///
		// REPLAY BOT: RECORDING
		///
		if(g_hRecording[client] != INVALID_HANDLE && !IsFakeClient(client))
		{
			new iFrame[FRAME_INFO_SIZE];
			iFrame[playerButtons] = buttons;
			iFrame[playerImpulse] = impulse;
			
			new Float:vVel[3];
			Entity_GetAbsVelocity(client, vVel);
			iFrame[actualVelocity] = vVel;
			iFrame[predictedVelocity] = vel;
			Array_Copy(angles, iFrame[predictedAngles], 2);
			iFrame[newWeapon] = CSWeapon_NONE;
			iFrame[playerSubtype] = subtype;
			iFrame[playerSeed] = seed;	
			if(g_iOriginSnapshotInterval[client] > ORIGIN_SNAPSHOT_INTERVAL)
			{
				new Float:origin2[3], iAT[AT_SIZE];
				GetClientAbsOrigin(client, origin2);
				Array_Copy(origin2, iAT[_:atOrigin], 3);
				iAT[_:atFlags] |= ADDITIONAL_FIELD_TELEPORTED_ORIGIN;
				PushArrayArray(g_hRecordingAdditionalTeleport[client], iAT, AT_SIZE);
				g_iOriginSnapshotInterval[client] = 0;
			}			
			g_iOriginSnapshotInterval[client]++;
			if(GetArraySize(g_hRecordingAdditionalTeleport[client]) > g_iCurrentAdditionalTeleportIndex[client])
			{
				new iAT[AT_SIZE];
				GetArrayArray(g_hRecordingAdditionalTeleport[client], g_iCurrentAdditionalTeleportIndex[client], iAT, AT_SIZE);
				iFrame[additionalFields] |= iAT[_:atFlags];
				g_iCurrentAdditionalTeleportIndex[client]++;
			}
			
			if (g_bPause[client])
				iFrame[pause] = 1;
			else
				iFrame[pause] = 0;
				
			new iNewWeapon = -1;
			
			if(weapon)
				iNewWeapon = weapon;
			else
			{
				new iWeapon = Client_GetActiveWeapon(client);
				if(iWeapon != -1 && (g_iRecordedTicks[client] == 0 || g_iRecordPreviousWeapon[client] != iWeapon))
					iNewWeapon = iWeapon;
			}
			
			if(iNewWeapon != -1)
			{
				if(IsValidEntity(iNewWeapon) && IsValidEdict(iNewWeapon))
				{
					g_iRecordPreviousWeapon[client] = iNewWeapon;				
					new String:sClassName[64];
					GetEdictClassname(iNewWeapon, sClassName, sizeof(sClassName));
					ReplaceString(sClassName, sizeof(sClassName), "weapon_", "", false);					
					new String:sWeaponAlias[64];
					CS_GetTranslatedWeaponAlias(sClassName, sWeaponAlias, sizeof(sWeaponAlias));
					new CSWeaponID:weaponId = CS_AliasToWeaponID(sWeaponAlias);			
					iFrame[newWeapon] = weaponId;
				}
			}
			
			PushArrayArray(g_hRecording[client], iFrame, _:FrameInfo);			
			g_iRecordedTicks[client]++;
		}
		///////////////////////////////////
		///
		// REPLAY BOT: REPLAY
		///
		else if(g_hBotMimicsRecord[client] != INVALID_HANDLE && IsFakeClient(client))
		{
			if(!IsPlayerAlive(client) || GetClientTeam(client) < CS_TEAM_T)
				return Plugin_Continue;
			
			if(g_iBotMimicTick[client] >= g_iBotMimicRecordTickCount[client])
			{
				g_iBotMimicTick[client] = 0;
				g_iCurrentAdditionalTeleportIndex[client] = 0;
			}			
			new iFrame[FRAME_INFO_SIZE];
			GetArrayArray(g_hBotMimicsRecord[client], g_iBotMimicTick[client], iFrame, _:FrameInfo);		
			buttons = iFrame[playerButtons];
			impulse = iFrame[playerImpulse];
			Array_Copy(iFrame[predictedVelocity], vel, 3);
			Array_Copy(iFrame[predictedAngles], angles, 2);
			subtype = iFrame[playerSubtype];
			seed = iFrame[playerSeed];
			weapon = 0;					
			decl Float:fAcutalVelocity[3];
			Array_Copy(iFrame[actualVelocity], fAcutalVelocity, 3);
			if(iFrame[additionalFields] & (ADDITIONAL_FIELD_TELEPORTED_ORIGIN|ADDITIONAL_FIELD_TELEPORTED_ANGLES|ADDITIONAL_FIELD_TELEPORTED_VELOCITY))
			{
				new iAT[AT_SIZE], Handle:hAdditionalTeleport, String:sPath[PLATFORM_MAX_PATH];
				if (client==g_iBot)
					Format(sPath, sizeof(sPath), "data/kz_replays/%s.rec", g_szMapName);
				else
					Format(sPath, sizeof(sPath), "data/kz_replays/%s_tp.rec", g_szMapName);
				BuildPath(Path_SM, sPath, sizeof(sPath), "%s", sPath);
				if (g_hLoadedRecordsAdditionalTeleport != INVALID_HANDLE)
				{
					GetTrieValue(g_hLoadedRecordsAdditionalTeleport, sPath, hAdditionalTeleport);
					GetArrayArray(hAdditionalTeleport, g_iCurrentAdditionalTeleportIndex[client], iAT, AT_SIZE);
					new Float:fOrigin[3], Float:fAngles[3], Float:fVelocity[3];
					Array_Copy(iAT[_:atOrigin], fOrigin, 3);
					Array_Copy(iAT[_:atAngles], fAngles, 3);
					Array_Copy(iAT[_:atVelocity], fVelocity, 3);
					g_bValidTeleportCall[client] = true;
					if(iAT[_:atFlags] & ADDITIONAL_FIELD_TELEPORTED_ORIGIN)
					{
						if(iAT[_:atFlags] & ADDITIONAL_FIELD_TELEPORTED_ANGLES)
						{
							if(iAT[_:atFlags] & ADDITIONAL_FIELD_TELEPORTED_VELOCITY)
								TeleportEntity(client, fOrigin, fAngles, fVelocity);
							else
								TeleportEntity(client, fOrigin, fAngles, NULL_VECTOR);
						}
						else
						{
							if(iAT[_:atFlags] & ADDITIONAL_FIELD_TELEPORTED_VELOCITY)
								TeleportEntity(client, fOrigin, NULL_VECTOR, fVelocity);
							else
								TeleportEntity(client, fOrigin, NULL_VECTOR, NULL_VECTOR);
						}
					}
					else
					{
						if(iAT[_:atFlags] & ADDITIONAL_FIELD_TELEPORTED_ANGLES)
						{
							if(iAT[_:atFlags] & ADDITIONAL_FIELD_TELEPORTED_VELOCITY)
								TeleportEntity(client, NULL_VECTOR, fAngles, fVelocity);
							else
								TeleportEntity(client, NULL_VECTOR, fAngles, NULL_VECTOR);
						}
						else
						{
							if(iAT[_:atFlags] & ADDITIONAL_FIELD_TELEPORTED_VELOCITY)
								TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, fVelocity);
						}
					}				
					g_iCurrentAdditionalTeleportIndex[client]++;
				}
			}
			new pausex
			pausex = iFrame[pause];
			if (pausex == 1 && !g_bPause[client])
				PauseMethod(client);
			else
			{
				if (pausex == 0 && g_bPause[client])
				PauseMethod(client);
			}
			if(g_iBotMimicTick[client] == 0)
			{
				SetEntPropEnt(client, Prop_Send, "m_hActiveWeapon", -1);
				CL_OnStartTimerPress(client);
				g_bValidTeleportCall[client] = true;
				TeleportEntity(client, g_fInitialPosition[client], g_fInitialAngles[client], fAcutalVelocity);
			}
			else
			{
				g_bValidTeleportCall[client] = true;
				TeleportEntity(client, NULL_VECTOR, angles, fAcutalVelocity);
			}
			
			if(iFrame[newWeapon] != CSWeapon_NONE)
			{
				decl String:sAlias[64];
				CS_WeaponIDToAlias(iFrame[newWeapon], sAlias, sizeof(sAlias));
				
				Format(sAlias, sizeof(sAlias), "weapon_%s", sAlias);
				
				if(g_iBotMimicTick[client] > 0 && Client_HasWeapon(client, sAlias))
				{
					weapon = Client_GetWeapon(client, sAlias);
					g_iBotActiveWeapon[client] = weapon;
					SetEntPropEnt(client, Prop_Send, "m_hActiveWeapon", weapon);
					Client_SetActiveWeapon(client, weapon);
				}
				else
				{
					weapon = Client_GiveWeapon(client, sAlias, false);
					g_iBotActiveWeapon[client] = weapon;
					SetEntPropEnt(client, Prop_Send, "m_hActiveWeapon", weapon);
					Client_SetActiveWeapon(client, weapon);
				}
			}		
			g_iBotMimicTick[client]++;		
		}	
		
		//slowdown
		if (g_bJumpPenalty[client] && !IsFakeClient(client))
		{
			if (!(GetEntityFlags(client) & FL_ONGROUND) && g_bOnGround[client])	
			g_bOnGround[client]=false;
			if ((GetEntityFlags(client) & FL_ONGROUND) && !g_bOnGround[client])	
			{
				g_bOnGround[client]=true;	
				g_bSlowDownCheck[client]=true;
				SetEntPropFloat(client, Prop_Send, "m_flVelocityModifier", 0.49);
				CreateTimer(2.0, ResetSlowdownTimer, client,TIMER_FLAG_NO_MAPCHANGE);
			}
		}	
				
		///////////////////////////////////
		///
		//JUMPSTATS
		///
		//Set GroundFrame
		if (g_bPlayerJumped[client] == false && GetEntityFlags(client) & FL_ONGROUND && ((buttons & IN_MOVERIGHT) || (buttons & IN_MOVELEFT) || (buttons & IN_BACK) || (buttons & IN_FORWARD)))
			g_ground_frames[client]++;
		
					
		// prestrafe (forward)
		//PRESTRAFE+USPSPEED 250.0 (TICKRATE 64 + 128 optimized)
		if (g_bPreStrafe && !g_bSlowDownCheck[client])
		{
			decl String:classname[64];
			GetClientWeapon(client, classname, 64);
			if ((GetEntityFlags(client) & FL_ONGROUND) && ((buttons & IN_MOVERIGHT) || (buttons & IN_MOVELEFT)))
			{          
				new g_mouseAbs = mouse[0] - g_mouseDirOld[client];
				if (g_mouseAbs < 0)
					g_mouseAbs = g_mouseAbs*-1;
				if ((buttons & IN_MOVERIGHT && mouse[0] > 0 && g_mouseAbs < 20) || (buttons & IN_MOVELEFT && mouse[0] < 0 && g_mouseAbs < 20))
				{            
					g_PrestrafeFrameCounter[client]++;
					new x;
					if (g_btickrate64)
						x = 50;
					else
						x = 120;
					if (g_PrestrafeFrameCounter[client] < x)
					{
						g_PrestrafeVelocity[client]+=0.00213;
						
						if(StrEqual(classname, "weapon_hkp2000"))
						{
							if (g_PrestrafeVelocity[client] > 1.149)
								g_PrestrafeVelocity[client]-=0.022;
						}
						else
						{
							if (g_PrestrafeVelocity[client] > 1.107)
								g_PrestrafeVelocity[client]-=0.022;
						}
						SetEntPropFloat(client, Prop_Send, "m_flVelocityModifier", g_PrestrafeVelocity[client]);						
					}
					else
					{
						g_PrestrafeVelocity[client]-=0.003;
						if(StrEqual(classname, "weapon_hkp2000"))
						{
							if (g_PrestrafeVelocity[client]< 1.042)
								g_PrestrafeVelocity[client]= 1.042;
						}
						else						
						if (g_PrestrafeVelocity[client]< 1.0)
							g_PrestrafeVelocity[client]= 1.0;
						g_PrestrafeFrameCounter[client] = g_PrestrafeFrameCounter[client] - 2;
						SetEntPropFloat(client, Prop_Send, "m_flVelocityModifier", g_PrestrafeVelocity[client]);
					}
				}
				else
				{
					g_PrestrafeVelocity[client]-=0.03;				
					if(StrEqual(classname, "weapon_hkp2000"))
					{
						if (g_PrestrafeVelocity[client]< 1.042)
							g_PrestrafeVelocity[client]= 1.042;
					}
					else						
					if (g_PrestrafeVelocity[client]< 1.0)
						g_PrestrafeVelocity[client]= 1.0;
					SetEntPropFloat(client, Prop_Send, "m_flVelocityModifier", g_PrestrafeVelocity[client]);
				}
			}
			else
			{
				if(StrEqual(classname, "weapon_hkp2000"))
					g_PrestrafeVelocity[client] = 1.042;
				else
					g_PrestrafeVelocity[client] = 1.0;	
				SetEntPropFloat(client, Prop_Send, "m_flVelocityModifier", g_PrestrafeVelocity[client]);
				g_PrestrafeFrameCounter[client] = 0;
			}
			g_mouseDirOld[client] = mouse[0];
		}
		
		//Timer Panel
		if (g_bTimeractivated[client] && !g_bPause[client])
		{
			if (g_bClimbersMenuOpen[client] == false)
				PlayerPanel(client);
		}
		
		//refresh ClimbersMenu when timer active
		if (g_bTimeractivated[client])
		{
			if (g_bClimbersMenuOpen[client] && !g_bMenuOpen[client])
				ClimbersMenu(client);
			else
				if (g_bClimbersMenuwasOpen[client]  && !g_bMenuOpen[client])
				{
					g_bClimbersMenuwasOpen[client]=false;
					ClimbersMenu(client);	
				}		
		}
		//Standup bunnyhop?
		if (g_bPlayerJumped[client] == true && !g_bStandUpBhop[client])
		{
			new Float: y = GetEngineTime() - g_fLastJumpTime[client];
			if (y <= 0.09)
			{
				if (buttons & IN_DUCK)
					g_bStandUpBhop[client]=true;
			}
		}	
		if (buttons & IN_DUCK)		
			g_fLastTimeDucked[client] = GetEngineTime();			

		//Surf Protection
		if (g_bCheckSurf[client] == true && g_bPlayerJumped[client] == true)
		{		
			g_LeetJumpDominating[client]=0;
			g_ground_frames[client] = 0;
			g_bPlayerJumped[client] = false;
			g_bCheckSurf[client] = false;
		}
		
		//Block Teleports
		new Float:pos[3];
		GetClientAbsOrigin(client, pos);
		new Float:sum = FloatAbs(pos[0]) - FloatAbs(g_fPosOld[client][0]);
		if (sum > 10 || sum < -10)
		{
				if (g_bPlayerJumped[client])	
				{
					g_LeetJumpDominating[client]=0;
					g_bPlayerJumped[client] = false;
				}	
		}
		sum = FloatAbs(pos[1]) - FloatAbs(g_fPosOld[client][1]);
		if (sum > 10 || sum < -10)
		{
			if (g_bPlayerJumped[client])
			{
				g_bPlayerJumped[client] = false;
				g_LeetJumpDominating[client]=0;
			}
				
		}
		GetClientAbsOrigin(client, g_fPosOld[client]);
		
		//noclip used?
		new MoveType:mt2 = GetEntityMoveType(client);  
		if(!(GetEntityFlags(client) & FL_ONGROUND))
		{	
			if (mt2 == MOVETYPE_NOCLIP)
				g_bNoClipUsed[client]=true;
		}
		else
		{		
			if (g_ground_frames[client] > 10)
				g_bNoClipUsed[client]=false;
		}
		
		//ladder detection
		if (GetEntityMoveType(client) == MOVETYPE_LADDER)
		{
			g_ground_frames[client] = 0;
			g_LeetJumpDominating[client]=0;
			g_bPlayerJumped[client] = false;					
		}
		
		//water detection
		if (GetEntProp(client, Prop_Data, "m_nWaterLevel") > 0)
		{
			g_ground_frames[client] = 0;
			g_LeetJumpDominating[client]=0;
			g_bPlayerJumped[client] = false;		
		}
		
		//noclip detection
		new MoveType:mt = GetEntityMoveType(client);   
		if(mt == MOVETYPE_NOCLIP && (g_bPlayerJumped[client] || g_bTimeractivated[client]))
		{
			g_bPlayerJumped[client] = false;
			g_LeetJumpDominating[client]=0;
			g_bTimeractivated[client] = false;
		}

		//speed cap
		static bool:IsOnGround[MAXPLAYERS + 1]; 
		if (IsPlayerAlive(client)  && !IsFakeClient(client))
		{
			new ClientFlags = GetEntityFlags(client);
			if (ClientFlags & FL_ONGROUND)
			{
				if (!IsOnGround[client])
				{
					IsOnGround[client] = true;    
					new Float:CurVelVec[3];
					GetEntPropVector(client, Prop_Data, "m_vecVelocity", CurVelVec);
					if (GetVectorLength(CurVelVec) > g_fBhopSpeedCap)
					{
						
						NormalizeVector(CurVelVec, CurVelVec);
						ScaleVector(CurVelVec, g_fBhopSpeedCap);
						TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, CurVelVec);
					}
				}
			}
			else
				IsOnGround[client] = false;
		}

		//get player speed
		new Float:fspeed = GetSpeed(client);	

		//strafestats
		new Float:rangles[3];
		GetClientEyeAngles(client, rangles);
		new bool: turning_right = false;
		new bool: turning_left = false;

		if( rangles[1] < g_OldAngle[client])
			turning_right = true;
		else 
			if( rangles[1] > g_OldAngle[client])
				turning_left = true;	
		g_OldAngle[client] = rangles[1];
			
		
		if (g_bPlayerJumped[client] == true)
		{
			//strafestats
			if(turning_left || turning_right)
			{
				if( !g_strafing_aw[client] && ((buttons & IN_FORWARD) || (buttons & IN_MOVELEFT)) && !(buttons & IN_MOVERIGHT) && !(buttons & IN_BACK) )
				{
					g_strafing_aw[client] = true;
					g_strafing_sd[client] = false;					
					g_strafecount[client]++; 
					g_strafe_good_sync[client][g_strafecount[client]-1] = 0.0;
					g_strafe_frames[client][g_strafecount[client]-1] = 0.0;		
					g_strafe_max_speed[client][g_strafecount[client] - 1] = fspeed;	
				}
				else if( !g_strafing_sd[client] && ((buttons & IN_BACK) || (buttons & IN_MOVERIGHT)) && !(buttons & IN_MOVELEFT) && !(buttons & IN_FORWARD) )
				{
					g_strafing_aw[client] = false;
					g_strafing_sd[client] = true;
					g_strafecount[client]++; 
					g_strafe_good_sync[client][g_strafecount[client]-1] = 0.0;
					g_strafe_frames[client][g_strafecount[client]-1] = 0.0;		
					g_strafe_max_speed[client][g_strafecount[client] - 1] = fspeed;		
				}				
			}
			
			//ducked in air
			if (g_last_ground_frames[client] > 11 && !(GetEntityFlags(client) & FL_ONGROUND))
			{
				if (GetClientButtons(client) == IN_DUCK)
					g_bDuckInAir[client]=true;
			}			
			//calc maxspeed
			if (g_fOldSpeed[client] < fspeed)
				g_fMaxSpeed[client] = fspeed;
										
			//sync
			if( g_fOldSpeed[client] < fspeed )
			{
				g_good_sync[client]++;		
				if( 0 < g_strafecount[client] <= MAX_STRAFES )
				{
					g_strafe_good_sync[client][g_strafecount[client] - 1]++;
					g_strafe_gained[client][g_strafecount[client] - 1] += (fspeed - g_fOldSpeed[client]);
				}
			}	
			else 
				if( g_fOldSpeed[client] > fspeed )
				{
					if( 0 < g_strafecount[client] <= MAX_STRAFES )
						g_strafe_lost[client][g_strafecount[client] - 1] += (g_fOldSpeed[client] - fspeed);
				}

			//strafe frames
			if( 0 < g_strafecount[client] <= MAX_STRAFES )
			{
				g_strafe_frames[client][g_strafecount[client] - 1]++;
				if( g_strafe_max_speed[client][g_strafecount[client] - 1] < fspeed )
					g_strafe_max_speed[client][g_strafecount[client] - 1] = fspeed;
			}
			//total frames
			g_sync_frames[client]++;
			
			//gravity detection
			new Float:flGravity = GetEntityGravity(client);		
			if ((flGravity != 0.0 && flGravity !=1.0))
			{
				g_ground_frames[client] = 0;
				g_LeetJumpDominating[client]=0;
				g_bPlayerJumped[client] = false;		
			}
			
			//get jump height
			new Float:height[3];
			GetClientAbsOrigin(client, height);
			if (height[2] > g_fMaxHeight[client])
				g_fMaxHeight[client] = height[2];	
								
			//booster detection
			new Float:flbaseVelocity[3];
			GetEntPropVector(client, Prop_Data, "m_vecBaseVelocity", flbaseVelocity);
			if (flbaseVelocity[0] != 0.0 || flbaseVelocity[1] != 0.0 || flbaseVelocity[2] != 0.0)
			{
				
				g_ground_frames[client] = 0;
				g_LeetJumpDominating[client]=0;
				g_bPlayerJumped[client] = false;						
			}			
		}
		g_fOldSpeed[client] = fspeed;		
		
		
		//last jump height
		if(GetEntityFlags(client) & FL_ONGROUND && g_bPlayerJumped[client] == false && g_ground_frames[client] > 11)
		{
			decl Float:flPos[3];
			GetClientAbsOrigin(client, flPos);	
			g_fJump_InitialLastHeight[client] = flPos[2];
			if (buttons & IN_JUMP)
				g_bLastButtonJump[client] = true;
			else
				g_bLastButtonJump[client] = false;
		}
		
		new Float:distance = GetVectorDistance(g_fLastPosition[client], origin);
		if(distance > 25.0)
		{
			if(g_bPlayerJumped[client])
				g_bPlayerJumped[client] = false;
		}
		
		// landed?		
		if(GetEntityFlags(client) & FL_ONGROUND && !g_bInvalidGround[client] && !g_bLastInvalidGround[client] && g_bPlayerJumped[client] == true && weapon != -1 && IsValidEntity(weapon) && GetEntProp(client, Prop_Data, "m_nWaterLevel") < 1)
		{		
			if (g_bJumpStats)
				Postthink(client);
		}
		// last ground check (invalid?)
		if (GetEntityFlags(client) & FL_ONGROUND)
			g_bLastInvalidGround[client] = g_bInvalidGround[client];
					
		// reset ground frames (wj)
		if (!(GetEntityFlags(client) & FL_ONGROUND) && g_bPlayerJumped[client] == false)
			g_ground_frames[client] = 0;		

		g_fLastAngle[client] = ang[1];
		g_fLastVelocity[client] = newvelo;
		g_fLastPosition[client] = origin;
		g_LastButton[client] = buttons;
	}	
	return Plugin_Continue;
}


public Action:Event_OnJump(Handle:Event, const String:Name[], bool:Broadcast)
{
	new client = GetClientOfUserId(GetEventInt(Event, "userid"));
	if (g_bJumpStats)
		Prethink(client);
}

public Prethink (client)
{	
	if (!client)
		return;
	new weapon = GetEntPropEnt(client, Prop_Data, "m_hActiveWeapon");
	if (!g_bSpectate[client] && IsPlayerAlive(client) && weapon != -1 && IsClientInGame(client))
	{
		//water level?
		if (GetEntProp(client, Prop_Data, "m_nWaterLevel") > 0)
			return;
		decl Float:flVelocity[3];
		
		//booster or moving plattform?
		GetEntPropVector(client, Prop_Data, "m_vecBaseVelocity", flVelocity);
		if (flVelocity[0] != 0.0 || flVelocity[1] != 0.0 || flVelocity[2] != 0.0)
			g_bInvalidGround[client] = true;
		else
			g_bInvalidGround[client] = false;		
		
		//reset vars
		g_good_sync[client] = 0.0;
		g_sync_frames[client] = 0.0;
		for( new i = 0; i < MAX_STRAFES; i++ )
		{
			g_strafe_good_sync[client][i] = 0.0;
			g_strafe_frames[client][i] = 0.0;
			g_strafe_gained[client][i] = 0.0;
			g_strafe_lost[client][i] = 0.0;
			g_strafe_max_speed[client][i] = 0.0;
		}		
		g_fJumpOffTime[client] = GetEngineTime();
		g_fMaxSpeed[client] = 0.0;
		g_strafecount[client] = 0;
		g_bDuckInAir[client] = false;
		g_bPlayerJumped[client] = true;
		g_bCheckSurf[client] = false;
		g_bStandUpBhop[client] = false;
		g_strafing_aw[client] = false;
		g_strafing_sd[client] = false;
		g_fMaxHeight[client] = -99999.0;			
		
		//get start position
		GetClientAbsOrigin(client, g_fJump_Initial[client]);	
		
		//get prestrafe & takeoff speed
		decl Float:fVelocity[3];
		GetEntPropVector(client, Prop_Data, "m_vecVelocity", fVelocity);
		g_fPreStrafe[client] = SquareRoot(Pow(fVelocity[0], 2.0) + Pow(fVelocity[1], 2.0) + Pow(fVelocity[2], 2.0));	
		g_fTakeOffSpeed[client] = -1.0;
		CreateTimer(0.015, GetTakeOffSpeedTimer, client,TIMER_FLAG_NO_MAPCHANGE);
		
		//DropJump?
		if (g_fJump_InitialLastHeight[client] != -1.012345)
		{				
			new Float: fGroundDiff = g_fJump_Initial[client][2] - g_fJump_InitialLastHeight[client];
			if(fGroundDiff < -1.9)
				g_bDropJump[client] = true;
			else
			{
				//must be here because touchwall detects some grounds too *csgo
				if (g_bTouchWall[client])
				{
					g_bPlayerJumped[client]=false;
					return;
				}
				g_bDropJump[client] = false;
			}
			if (g_bDropJump[client])
				g_fDroppedUnits[client] = FloatAbs(fGroundDiff);
		}
		
		//StandUpBhop?
		g_fLastJumpTime[client] = GetEngineTime();
		new Float: x = GetEngineTime() - g_fLastTimeDucked[client];
		if (x <= 0.1)
		{
			g_bStandUpBhop[client]=true;
		}
				
		//Noclip Used? blocks noclip boost at the timer
		if (g_bNoClipUsed[client])
		{
			g_bPlayerJumped[client]=false;
			g_bNoClipUsed[client]=false;
		}
		
		//last InitialLastHeight
		g_fJump_InitialLastHeight[client] = g_fJump_Initial[client][2];
	}
}

public Postthink(client)
{	
	if (!IsClientInGame(client))
		return;
	
	new ground_frames = g_ground_frames[client];
	new strafes = g_strafecount[client];
	g_ground_frames[client] = 0;	
	g_fMaxSpeed2[client] = g_fMaxSpeed[client];
	decl String:szName[128];	
	GetClientName(client, szName, 128);					
	GetClientAbsOrigin(client, g_fJump_Final[client]);

	//get landing position & calc distance
	g_fJump_DistanceX[client] = g_fJump_Final[client][0] - g_fJump_Initial[client][0];
	if(g_fJump_DistanceX[client] < 0)
		g_fJump_DistanceX[client] = -g_fJump_DistanceX[client];
	g_fJump_DistanceZ[client] = g_fJump_Final[client][1] - g_fJump_Initial[client][1];
	if(g_fJump_DistanceZ[client] < 0)
		g_fJump_DistanceZ[client] = -g_fJump_DistanceZ[client];
	g_fJump_Distance[client] = SquareRoot(Pow(g_fJump_DistanceX[client], 2.0) + Pow(g_fJump_DistanceZ[client], 2.0));		
	g_fJump_Distance[client] = g_fJump_Distance[client] + 32;		
		
	//ground diff
	new Float: fGroundDiff = g_fJump_Final[client][2] - g_fJump_Initial[client][2];
	new Float: fJump_Height;
	if(-1.9 < fGroundDiff < 1.9)
		fGroundDiff = 0.0;		
	
	//GetHeight
	if (FloatAbs(g_fJump_Initial[client][2]) > FloatAbs(g_fMaxHeight[client]))
		fJump_Height =  FloatAbs(g_fJump_Initial[client][2]) - FloatAbs(g_fMaxHeight[client]);
	else
		fJump_Height =  FloatAbs(g_fMaxHeight[client]) - FloatAbs(g_fJump_Initial[client][2]);
	
	g_flastHeight[client] = fJump_Height;
	
	//sync/strafes
	new sync = RoundToNearest(g_good_sync[client] / g_sync_frames[client] * 100.0);
	g_Strafes[client] = strafes;
	g_sync[client] = sync;
	
	//Calc & format strafe sync for chat output
	new String:szStrafeSync[255];
	new String:szStrafeSync2[255];
	new strafe_sync;
	if (g_bStrafeSync[client] && strafes > 1)
	{
		for (new i = 0; i < strafes; i++)
		{
			if (i==0)
				Format(szStrafeSync, 255, "[%cKZ%c] %cSync:",MOSSGREEN,WHITE,GRAY);
			if (g_strafe_frames[client][i] == 0.0 || g_strafe_good_sync[client][i] == 0.0) 
				strafe_sync = 0;
			else
				strafe_sync = RoundToNearest(g_strafe_good_sync[client][i] / g_strafe_frames[client][i] * 100.0);
			if (i==0)	
				Format(szStrafeSync2, 255, " %c%i.%c %i%c",GRAY, (i+1),LIMEGREEN,strafe_sync,PERCENT);
			else
				Format(szStrafeSync2, 255, "%c - %i.%c %i%c",GRAY, (i+1),LIMEGREEN,strafe_sync,PERCENT);
			StrCat(szStrafeSync, sizeof(szStrafeSync), szStrafeSync2);
			if ((i+1) == strafes)
			{
				Format(szStrafeSync2, 255, " %c[%c%i%c%c]",GRAY,PURPLE, sync,PERCENT,GRAY);
				StrCat(szStrafeSync, sizeof(szStrafeSync), szStrafeSync2);
			}
		}	
	}
	else
		Format(szStrafeSync,255, "");
		
	new String:szStrafeStats[1024];
	new String:szGained[16];
	new String:szLost[16];
	
	//Format StrafeStats Console
	if(strafes > 1)
	{
		Format(szStrafeStats,1024, " #. Sync        Gained      Lost        MaxSpeed\n");
		for( new i = 0; i < strafes; i++ )
		{
			new sync2 = RoundToNearest(g_strafe_good_sync[client][i] / g_strafe_frames[client][i] * 100.0);
			if (sync2 < 0)
				sync2 = 0;
			if (g_strafe_gained[client][i] < 10.0)
				Format(szGained,16, "%.3f ", g_strafe_gained[client][i]);
			else
				Format(szGained,16, "%.3f", g_strafe_gained[client][i]);
			if (g_strafe_lost[client][i] < 10.0)
				Format(szLost,16, "%.3f ", g_strafe_lost[client][i]);
			else
				Format(szLost,16, "%.3f", g_strafe_lost[client][i]);				
			Format(szStrafeStats,1024, "%s%2i. %3i%s        %s      %s      %3.3f\n",\
			szStrafeStats,\
			i + 1,\
			sync2,\
			PERCENT,\
			szGained,\
			szLost,\
			g_strafe_max_speed[client][i]);
		}
	}
	else
		Format(szStrafeStats,1024, "");
	
	//t00-b4d
	if(g_fJump_Distance[client] < 200.0)
	{
		//multibhop count proforma
		if (g_last_ground_frames[client] < 11 && ground_frames < 11 && fGroundDiff == 0.0  && fJump_Height <= 66.0 && !g_bDropJump[client])
			g_multi_bhop_count[client]++;
		else
			g_multi_bhop_count[client]=1;
		if (fGroundDiff==0.0)
			g_fLastJumpDistance[client] = g_fJump_Distance[client];	
		PostThinkPost(client, ground_frames);
		return;
	}

	
	
	//change BotName (szName) for jumpstats output
	if (client == g_iBot)
		Format(szName,sizeof(szName), "%s (Pro Replay)", g_szReplayName);		
	if (client == g_iBot2)
		Format(szName,sizeof(szName), "%s (TP Replay)", g_szReplayNameTp);	
		
	//Chat Output
	//LongJump
	if (ground_frames > 11 && fGroundDiff == 0.0 && 200.0 < g_fPreStrafe[client] < 278.0 && fJump_Height <= 66.0) 
	{	
		//WORKAROUND..probably already fixed.. happened at the beneath the water mill on kz_olympus
		if ((!IsFakeClient(client) && strafes < 5 && g_fJump_Distance[client] > 254.0 && g_btickrate64) || ((!IsFakeClient(client) && strafes < 5 && g_fJump_Distance[client] > 260.0 && !g_btickrate64)) || (!IsFakeClient(client) && (g_fTakeOffSpeed[client] < 235.0 || strafes == 0)) || (IsFakeClient(client) && g_fJump_Distance[client] > 270.0))
		{
			PostThinkPost(client, ground_frames);
			return;
		}
		//block invalid bot distances (has something to do with the ground-detection of the replay bot) WORKAROUND
		if (IsFakeClient(client) && g_fJump_Distance[client] > (g_dist_leet_lj * 1.05))
		{
			PostThinkPost(client, ground_frames);
			return;
		}
		
		//last distance (speedmeter)
		g_fLastJumpDistance[client] = g_fJump_Distance[client];
		
		//check if kz_prestrafe is enabled
		decl String:szVr[16];	
		if (!g_bPreStrafe)	
		{
			g_fPreStrafe[client] = g_fTakeOffSpeed[client];
			Format(szVr, 16, "TakeOff");
		}
		else
			Format(szVr, 16, "Pre");
			
		//good?
		if (g_fJump_Distance[client] >= g_dist_good_lj && g_fJump_Distance[client] < g_dist_pro_lj)	
		{
			g_LeetJumpDominating[client]=0;		
			PrintToChat(client, "[%cKZ%c] %cLJ: %.2f units [%c%i%c Strafes | %c%.0f%c %s | %c%3.f%c Max | %c%.0f%c Height | %c%i%c%c Sync]",MOSSGREEN,WHITE,GRAY, g_fJump_Distance[client],LIMEGREEN,strafes,GRAY, LIMEGREEN, g_fPreStrafe[client], GRAY,szVr,LIMEGREEN,g_fMaxSpeed2[client],GRAY,LIMEGREEN, fJump_Height,GRAY,LIMEGREEN, sync,PERCENT,GRAY);			
			PrintToConsole(client, "        ");
			PrintToConsole(client, "[KZ] %s jumped %0.4f units with a LongJump [%i Strafes | %.3f %s | %.3f Max | Height %.1f | %i%c Sync]",szName, g_fJump_Distance[client],strafes, g_fPreStrafe[client], szVr,g_fMaxSpeed2[client],fJump_Height,sync,PERCENT);
			PrintToConsole(client, "%s", szStrafeStats);
			}
		else
			//pro?
			if (g_fJump_Distance[client] >= g_dist_pro_lj && g_fJump_Distance[client] < g_dist_leet_lj)	
			{
				g_LeetJumpDominating[client]=0;
				//chat & sound client		
				PrintToConsole(client, "        ");
				PrintToConsole(client, "[KZ] %s jumped %0.4f units with a LongJump [%i Strafes | %.3f %s | %.3f Max | Height %.1f | %i%c Sync]",szName, g_fJump_Distance[client],strafes, g_fPreStrafe[client],szVr, g_fMaxSpeed2[client],fJump_Height,sync,PERCENT);
				PrintToConsole(client, "%s", szStrafeStats);		
				PrintToChat(client, "[%cKZ%c] %cLJ%c: %c%.2f units%c [%c%i%c Strafes | %c%.0f%c %s |  %c%0.f%c Max | %c%.0f%c Height | %c%i%c%c Sync]",MOSSGREEN,WHITE,GREEN,GRAY,GREEN,g_fJump_Distance[client],GRAY,LIMEGREEN,strafes,GRAY,LIMEGREEN,g_fPreStrafe[client],GRAY,szVr,LIMEGREEN,g_fMaxSpeed2[client],GRAY,LIMEGREEN, fJump_Height,GRAY,LIMEGREEN, sync,PERCENT,GRAY);
			
				decl String:buffer[255];
				Format(buffer, sizeof(buffer), "play %s", PROJUMP_RELATIVE_SOUND_PATH); 			
				if (g_bEnableQuakeSounds[client])
					ClientCommand(client, buffer); 						
				PlayQuakeSound_Spec(client,buffer);		
				//chat all
				for (new i = 1; i <= MaxClients; i++)
				{
					if (1 <= i <= MaxClients && IsClientInGame(i) && IsValidEntity(i))
					{						
						if (g_bColorChat[i] && i != client)
							PrintToChat(i, "%t", "Jumpstats_LjAll",MOSSGREEN,WHITE,GREEN,szName, MOSSGREEN,GREEN, g_fJump_Distance[client],MOSSGREEN,GREEN);
					}
				}	
				
			}	
			//leet?
			else		
			{	
				if (g_fJump_Distance[client] >= g_dist_leet_lj)	
				{
					g_LeetJumpDominating[client]++;
					//client		
					PrintToConsole(client, "        ");
					PrintToConsole(client, "[KZ] %s jumped %0.4f units with a LongJump [%i Strafes | %.3f %s | %.3f Max | Height %.1f | %i%c Sync]",szName, g_fJump_Distance[client],strafes, g_fPreStrafe[client],szVr, g_fMaxSpeed2[client],fJump_Height,sync,PERCENT);
					PrintToConsole(client, "%s", szStrafeStats);						
					PrintToChat(client, "[%cKZ%c] %cLJ%c: %c%.2f units%c [%c%i%c Strafes | %c%.0f%c %s | %c%0.f%c Max | %c%.0f%c Height | %c%i%c%c Sync]",MOSSGREEN,WHITE,DARKRED,GRAY,DARKRED,g_fJump_Distance[client],GRAY,LIMEGREEN,strafes,GRAY,LIMEGREEN,g_fPreStrafe[client],GRAY,szVr,LIMEGREEN, g_fMaxSpeed2[client],GRAY,LIMEGREEN, fJump_Height,GRAY,LIMEGREEN, sync,PERCENT,GRAY);
					if (g_LeetJumpDominating[client]==3)
						PrintToChat(client, "%t", "Jumpstats_OnRampage",MOSSGREEN,WHITE,YELLOW,szName);
					else
						if (g_LeetJumpDominating[client]==5)
							PrintToChat(client, "%t", "Jumpstats_IsDominating",MOSSGREEN,WHITE,YELLOW,szName);
					
					//all
					for (new i = 1; i <= MaxClients; i++)
					{
						if (1 <= i <= MaxClients && IsClientInGame(i) && IsValidEntity(i))
						{						
							if (g_bColorChat[i] && i != client)
							{
								PrintToChat(i, "%t", "Jumpstats_LjAll",MOSSGREEN,WHITE,DARKRED,szName, RED,DARKRED, g_fJump_Distance[client],RED,DARKRED);
								if (g_LeetJumpDominating[client]==3)
									PrintToChat(i, "%t", "Jumpstats_OnRampage",MOSSGREEN,WHITE,YELLOW,szName);
								else
									if (g_LeetJumpDominating[client]==5)
										PrintToChat(i, "%t", "Jumpstats_IsDominating",MOSSGREEN,WHITE,YELLOW,szName);
							}
						}
					}
					PlayLeetJumpSound(client);
					if (g_LeetJumpDominating[client] != 3 && g_LeetJumpDominating[client] != 5)
					{
						decl String:buffer[255];
						Format(buffer, sizeof(buffer), "play %s", LEETJUMP_RELATIVE_SOUND_PATH); 	
						PlayQuakeSound_Spec(client,buffer);
					}
				}
				else
					g_LeetJumpDominating[client] = 0;
			}
	
		//strafe sync chat
		if (g_bStrafeSync[client] && g_fJump_Distance[client] >= g_dist_good_lj)
			PrintToChat(client,"%s", szStrafeSync);		
				
		//new best
		if (g_fPersonalLjRecord[client] < g_fJump_Distance[client]  &&  !IsFakeClient(client))
		{		
			if (g_fPersonalLjRecord[client] > 0.0)
				PrintToChat(client, "%t", "Jumpstats_BeatLjBest",MOSSGREEN,WHITE,YELLOW, g_fJump_Distance[client]);
			g_fPersonalLjRecord[client] = g_fJump_Distance[client];
			db_updateLjRecord(client);
			
		}
	}
	//Multi Bhop
	if (g_last_ground_frames[client] < 11 && ground_frames < 11 && fGroundDiff == 0.0  && fJump_Height <= 66.0 && !g_bDropJump[client])
	{		
		g_multi_bhop_count[client]++;	
		//block boost through a booster (e.g. bhop_monster_jam_b1 vip room exit)
		if ((g_multi_bhop_count[client] == 1 && g_fPreStrafe[client] > 350.0))
		{
			PostThinkPost(client, ground_frames);
			return;		
		}

		//block invalid bot distances (has something to do with the ground-detection of the replay bot) WORKAROUND
		if (IsFakeClient(client) && g_fJump_Distance[client] > (g_dist_leet_multibhop * 1.05))
		{
			PostThinkPost(client, ground_frames);
			return;
		}
		
		g_fLastJumpDistance[client] = g_fJump_Distance[client];			
		
		//format bhop count
		decl String:szBhopCount[255];
		Format(szBhopCount, sizeof(szBhopCount), "%i", g_multi_bhop_count[client]);
		if (g_multi_bhop_count[client] > 8)
			Format(szBhopCount, sizeof(szBhopCount), "> 8");
		
		//good?	
		if (g_fJump_Distance[client] >= g_dist_good_multibhop && g_fJump_Distance[client] < g_dist_pro_multibhop)	
		{
			g_LeetJumpDominating[client]=0;
			PrintToChat(client, "[%cKZ%c] %cMultiBhop: %.2f units [%c%i%c Strafes | %c%.0f%c Pre | %c%i%c%c Sync]",MOSSGREEN,WHITE, GRAY, g_fJump_Distance[client],LIMEGREEN, strafes, GRAY, LIMEGREEN, g_fPreStrafe[client], GRAY, LIMEGREEN, sync,PERCENT,GRAY);	
			PrintToConsole(client, "        ");
			PrintToConsole(client, "[KZ] %s jumped %0.4f units with a MultiBhop [%i Strafes | %3.f Pre | %3.f Max | Height %.1f | %s Bhops | %i%c Sync]",szName, g_fJump_Distance[client],strafes, g_fPreStrafe[client], g_fMaxSpeed2[client], fJump_Height,szBhopCount,sync,PERCENT);				
			PrintToConsole(client, "%s", szStrafeStats);
		}	
		else
			//pro?
			if (g_fJump_Distance[client] >= g_dist_pro_multibhop && g_fJump_Distance[client] < g_dist_leet_multibhop)
			{				
				g_LeetJumpDominating[client]=0;
				//Client
				PrintToConsole(client, "        ");
				PrintToConsole(client, "[KZ] %s jumped %0.4f units with a MultiBhop [%i Strafes | %.3f Pre | %.3f Max |  Height %.1f | %s Bhops | %i%c Sync]",szName, g_fJump_Distance[client],strafes, g_fPreStrafe[client], g_fMaxSpeed2[client], fJump_Height,szBhopCount,sync,PERCENT);				
				PrintToConsole(client, "%s", szStrafeStats);					
				PrintToChat(client, "[%cKZ%c] %cMultiBhop%c: %c%.2f units%c [%c%i%c Strafes | %c%.0f%c Pre |  %c%0.f%c Max | %c%.0f%c Height | %c%s%c Bhops | %c%i%c%c Sync]",MOSSGREEN,WHITE,GREEN,GRAY,GREEN,g_fJump_Distance[client],GRAY,LIMEGREEN,strafes,GRAY,LIMEGREEN,g_fPreStrafe[client],GRAY,LIMEGREEN,g_fMaxSpeed2[client],GRAY,LIMEGREEN, fJump_Height,GRAY, LIMEGREEN,szBhopCount,GRAY,LIMEGREEN, sync,PERCENT,GRAY);
				
				decl String:buffer[255];
				Format(buffer, sizeof(buffer), "play %s", PROJUMP_RELATIVE_SOUND_PATH); 
				if (g_bEnableQuakeSounds[client])
					ClientCommand(client, buffer); 
				PlayQuakeSound_Spec(client,buffer);				
				//all
				for (new i = 1; i <= MaxClients; i++)
				{
					if (1 <= i <= MaxClients && IsClientInGame(i) && IsValidEntity(i))
					{
						if (g_bColorChat[i] && i != client)					
							PrintToChat(i, "%t", "Jumpstats_MultiBhopAll",MOSSGREEN,WHITE,GREEN,szName, MOSSGREEN,GREEN, g_fJump_Distance[client],MOSSGREEN,GREEN);
					}
				}
			}
			//leet?
			else
			if (g_fJump_Distance[client] >= g_dist_leet_multibhop)	
			{
				g_LeetJumpDominating[client]++;
				//Client
				PrintToConsole(client, "        ");
				PrintToConsole(client, "[KZ] %s jumped %0.4f units with a MultiBhop [%i Strafes | %.3f Pre | %.3f Max | Height %.1f | %s Bhops | %i%c Sync]",szName, g_fJump_Distance[client],strafes, g_fPreStrafe[client], g_fMaxSpeed2[client], fJump_Height,szBhopCount,sync,PERCENT);
				PrintToConsole(client, "%s", szStrafeStats);
				PrintToChat(client, "[%cKZ%c] %cMultiBhop%c: %c%.2f units%c [%c%i%c Strafes | %c%.0f%c Pre |  %c%0.f%c Max | %c%.0f%c Height | %c%s%c Bhops | %c%i%c%c Sync]",MOSSGREEN,WHITE,DARKRED,GRAY,DARKRED,g_fJump_Distance[client],GRAY,LIMEGREEN,strafes,GRAY,LIMEGREEN,g_fPreStrafe[client],GRAY,LIMEGREEN,g_fMaxSpeed2[client],GRAY,LIMEGREEN, fJump_Height,GRAY, LIMEGREEN,szBhopCount,GRAY,LIMEGREEN, sync,PERCENT,GRAY);
				if (g_LeetJumpDominating[client]==3)
					PrintToChat(client, "%t", "Jumpstats_OnRampage",MOSSGREEN,WHITE,YELLOW,szName);
				else
				if (g_LeetJumpDominating[client]==5)
					PrintToChat(client, "%t", "Jumpstats_IsDominating",MOSSGREEN,WHITE,YELLOW,szName);						
			
				//all
				for (new i = 1; i <= MaxClients; i++)
				{
					if (1 <= i <= MaxClients && IsClientInGame(i))
					{
						if (g_bColorChat[i] && i != client)
						{
							PrintToChat(i, "%t", "Jumpstats_MultiBhopAll",MOSSGREEN,WHITE,DARKRED,szName, RED,DARKRED, g_fJump_Distance[client],RED,DARKRED);
							if (g_LeetJumpDominating[client]==3)
									PrintToChat(i, "%t", "Jumpstats_OnRampage",MOSSGREEN,WHITE,YELLOW,szName);
								else
								if (g_LeetJumpDominating[client]==5)
									PrintToChat(i, "%t", "Jumpstats_IsDominating",MOSSGREEN,WHITE,YELLOW,szName);
						}
					}
				}
				PlayLeetJumpSound(client);	
				if (g_LeetJumpDominating[client] != 3 && g_LeetJumpDominating[client] != 5)
				{
					decl String:buffer[255];
					Format(buffer, sizeof(buffer), "play %s", LEETJUMP_RELATIVE_SOUND_PATH); 	
					PlayQuakeSound_Spec(client,buffer);
				}
			}	
			else
				g_LeetJumpDominating[client]=0;
		
		//strafe sync chat
		if (g_bStrafeSync[client] && g_fJump_Distance[client] >= g_dist_good_multibhop)
			PrintToChat(client,"%s", szStrafeSync);		
		
		//new best
		if (g_fPersonalMultiBhopRecord[client] < g_fJump_Distance[client] &&  !IsFakeClient(client))
		{
			if (g_fPersonalMultiBhopRecord[client] > 0.0)
				PrintToChat(client, "%t", "Jumpstats_BeatMultiBhopBest",MOSSGREEN,WHITE,YELLOW, g_fJump_Distance[client]);
			g_fPersonalMultiBhopRecord[client] = g_fJump_Distance[client];
			db_updateMultiBhopRecord(client);
		}
	}
	else
		g_multi_bhop_count[client] = 1;	

	//StandUp Drop Bunnyhop (detection works)
	/*if (ground_frames < 11 && g_last_ground_frames[client] > 11 && g_bLastButtonJump[client] && fGroundDiff == 0.0 && fJump_Height <= 66.0 && g_bDropJump[client] && g_bStandUpBhop[client])
	{
		if (g_fDroppedUnits[client] > 132.0)
			PrintToChat(client, "[%cKZ%c] You fell too far. (%c%.1f%c/%c132.0%c max)",MOSSGREEN,WHITE,RED,g_fDroppedUnits[client],WHITE,GREEN,WHITE);
		else
		{
			if (g_fPreStrafe[client]>300.0)
				PrintToChat(client, "[%cKZ%c] Your Prestrafe is too high. (%c%.1f%c/%c300.0%c max)",MOSSGREEN,WHITE,RED,g_fPreStrafe[client],WHITE,GREEN,WHITE);
			else
			{
				if (g_fJump_Distance[client] >= 250.0)	
				{
					g_LeetJumpDominating[client]=0;
					PrintToChat(client, "[%cKZ%c] StandUp DropBhop: %.2f units [%c%i%c Strafes | %c%.0f%c Pre]",MOSSGREEN,WHITE, g_fJump_Distance[client],MOSSGREEN, strafes, WHITE, MOSSGREEN, g_fPreStrafe[client],WHITE);	
				}	
			}
		}
	}*/
	
	//Drop Bunnyhop
	
	if (ground_frames < 11 && g_last_ground_frames[client] > 11 && g_bLastButtonJump[client] && fGroundDiff == 0.0 && fJump_Height <= 66.0 && g_bDropJump[client])
	{		
		if (g_fDroppedUnits[client] > 132.0)
		{
			if (g_fDroppedUnits[client] < 300.0)
				PrintToChat(client, "[%cKZ%c] You fell too far. (%c%.1f%c/%c132.0%c max) %cDropBhop%c",MOSSGREEN,WHITE,RED,g_fDroppedUnits[client],WHITE,GREEN,WHITE,GRAY,WHITE);
		}
		else
		{
			if (g_fPreStrafe[client] > g_fMaxBhopPreSpeed)
				PrintToChat(client, "[%cKZ%c] Your Prestrafe is too high. (%c%.3f%c/%c%.1f%c max) %cDropBhop%c",MOSSGREEN,WHITE,RED,g_fPreStrafe[client],WHITE,GREEN,g_fMaxBhopPreSpeed,WHITE,GRAY,WHITE);
			else
			{
				
				//block invalid bot distances (has something to do with the ground-detection of the replay bot) WORKAROUND
				if (IsFakeClient(client) && g_fJump_Distance[client] > (g_dist_leet_dropbhop * 1.05))
				{
					PostThinkPost(client, ground_frames);
					return;
				}
				
				g_fLastJumpDistance[client] = g_fJump_Distance[client];
				if (g_fJump_Distance[client] >= g_dist_good_dropbhop && g_fJump_Distance[client] < g_dist_pro_dropbhop)	
				{
					g_LeetJumpDominating[client]=0;	
					PrintToChat(client, "[%cKZ%c] %cDropBhop: %.2f units [%c%i%c Strafes | %c%.0f%c Pre  | %c%.0f%c Height | %c%i%c%c Sync]",MOSSGREEN,WHITE, GRAY,g_fJump_Distance[client],LIMEGREEN, strafes, GRAY, LIMEGREEN, g_fPreStrafe[client], GRAY, LIMEGREEN,fJump_Height,GRAY, LIMEGREEN,sync,PERCENT,GRAY);	
					PrintToConsole(client, "        ");
					PrintToConsole(client, "[KZ] %s jumped %0.4f units with a DropBhop [%i Strafes | %.3f Pre | %.3f Max | Height %.1f | %i%c Sync]",szName, g_fJump_Distance[client],strafes, g_fPreStrafe[client], g_fMaxSpeed2[client],fJump_Height,sync,PERCENT);						
					PrintToConsole(client, "%s", szStrafeStats);
				}	
				else
				if (g_fJump_Distance[client] >= g_dist_pro_dropbhop && g_fJump_Distance[client] < g_dist_leet_dropbhop)
				{
						g_LeetJumpDominating[client]=0;
						//Client
						PrintToConsole(client, "        ");
						PrintToChat(client, "[%cKZ%c] %cDropBhop%c: %c%.2f units%c [%c%i%c Strafes | %c%0.f%c Pre | %c%0.f%c Max  | %c%.0f%c Height | %c%i%c%c Sync]",MOSSGREEN,WHITE,GREEN,GRAY,GREEN,g_fJump_Distance[client],GRAY,LIMEGREEN,strafes,GRAY,LIMEGREEN,g_fPreStrafe[client],GRAY,LIMEGREEN, g_fMaxSpeed2[client],GRAY,LIMEGREEN, fJump_Height,GRAY, LIMEGREEN,sync,PERCENT,GRAY);	
						PrintToConsole(client, "[KZ] %s jumped %0.4f units with a DropBhop [%i Strafes | %.3f Pre | %.3f Max | Height %.1f | %i%c Sync]",szName, g_fJump_Distance[client],strafes, g_fPreStrafe[client], g_fMaxSpeed2[client],fJump_Height,sync,PERCENT);						
						PrintToConsole(client, "%s", szStrafeStats);
						decl String:buffer[255];
						Format(buffer, sizeof(buffer), "play %s", PROJUMP_RELATIVE_SOUND_PATH); 
						if (g_bEnableQuakeSounds[client])
							ClientCommand(client, buffer); 
						PlayQuakeSound_Spec(client,buffer);	
						//all
						for (new i = 1; i <= MaxClients; i++)
						{
							if (1 <= i <= MaxClients && IsClientInGame(i))
							{
								if (g_bColorChat[i]==true && i != client)
									PrintToChat(i, "%t", "Jumpstats_DropBhopAll",MOSSGREEN,WHITE,GREEN,szName, MOSSGREEN,GREEN, g_fJump_Distance[client],MOSSGREEN,GREEN);
							}
						}
					}
					else
						if (g_fJump_Distance[client] >= g_dist_leet_dropbhop)	
						{						
							g_LeetJumpDominating[client]++;
							//Client
							PrintToConsole(client, "        ");
							PrintToChat(client, "[%cKZ%c] %cDropBhop%c: %c%.2f units%c [%c%i%c Strafes | %c%0.f%c Pre | %c%0.f%c Max | %c%.0f%c Height | %c%i%c%c Sync]",MOSSGREEN,WHITE,DARKRED,GRAY,DARKRED,g_fJump_Distance[client],GRAY,LIMEGREEN,strafes,GRAY,LIMEGREEN,g_fPreStrafe[client],GRAY,LIMEGREEN, g_fMaxSpeed2[client],GRAY,LIMEGREEN,fJump_Height,GRAY, LIMEGREEN, sync,PERCENT,GRAY);	
							PrintToConsole(client, "[KZ] %s jumped %0.4f units with a DropBhop [%i Strafes | %.3f Pre | %.3f Max | Height %.1f | %i%c Sync]",szName, g_fJump_Distance[client],strafes, g_fPreStrafe[client], g_fMaxSpeed2[client],fJump_Height,sync,PERCENT);
							PrintToConsole(client, "%s", szStrafeStats);
							if (g_LeetJumpDominating[client]==3)
								PrintToChat(client, "%t", "Jumpstats_OnRampage",MOSSGREEN,WHITE,YELLOW,szName);
							else
								if (g_LeetJumpDominating[client]==5)
									PrintToChat(client, "%t", "Jumpstats_IsDominating",MOSSGREEN,WHITE,YELLOW,szName);
									
							//all
							for (new i = 1; i <= MaxClients; i++)
							{
								if (1 <= i <= MaxClients && IsClientInGame(i))
								{
									if (g_bColorChat[i]==true && i != client)
									{
										PrintToChat(i, "%t", "Jumpstats_DropBhopAll",MOSSGREEN,WHITE,DARKRED,szName, RED,DARKRED, g_fJump_Distance[client], RED,DARKRED);
										if (g_LeetJumpDominating[client]==3)
												PrintToChat(i, "%t", "Jumpstats_OnRampage",MOSSGREEN,WHITE,YELLOW,szName);
										else
											if (g_LeetJumpDominating[client]==5)
												PrintToChat(i, "%t", "Jumpstats_IsDominating",MOSSGREEN,WHITE,YELLOW,szName);
									}
								}	
							}
							PlayLeetJumpSound(client);	
							if (g_LeetJumpDominating[client] != 3 && g_LeetJumpDominating[client] != 5)
							{
								decl String:buffer[255];
								Format(buffer, sizeof(buffer), "play %s", LEETJUMP_RELATIVE_SOUND_PATH); 	
								PlayQuakeSound_Spec(client,buffer);
							}
						}		
						else
							g_LeetJumpDominating[client]=0;
				
				//strafesync chat
				if (g_bStrafeSync[client] && g_fJump_Distance[client] >= g_dist_good_dropbhop)
					PrintToChat(client,"%s", szStrafeSync);	
				
				//new best
				if (g_fPersonalDropBhopRecord[client] < g_fJump_Distance[client]  &&  !IsFakeClient(client))
				{
					if (g_fPersonalDropBhopRecord[client] > 0.0)
						PrintToChat(client, "%t", "Jumpstats_BeatDropBhopBest",MOSSGREEN,WHITE,YELLOW, g_fJump_Distance[client]);
					g_fPersonalDropBhopRecord[client] = g_fJump_Distance[client];
					db_updateDropBhopRecord(client);
				}				
			}
		}
	}
	// WeirdJump
	if (ground_frames < 11 && !g_bLastButtonJump[client] && fGroundDiff == 0.0 && fJump_Height <= 66.0 && g_bDropJump[client])
	{						
			if (g_fDroppedUnits[client] > 132.0)
			{
				if (g_fDroppedUnits[client] < 300.0)
					PrintToChat(client, "[%cKZ%c] You fell too far. (%c%.1f%c/%c132.0%c max) %cWJ%c",MOSSGREEN,WHITE,RED,g_fDroppedUnits[client],WHITE,GREEN,WHITE,GRAY,WHITE);
			}
			else
			{
				if (g_fPreStrafe[client] > 300)
					PrintToChat(client, "[%cKZ%c] Your Prestrafe is too high. (%c%.3f%c/%c300.0%c max) %cWJ%c",MOSSGREEN,WHITE,RED,g_fPreStrafe[client],WHITE,GREEN,WHITE,GRAY,WHITE);
				else
				{
					//block invalid bot distances (has something to do with the ground-detection of the replay bot) WORKAROUND
					if (IsFakeClient(client) && g_fJump_Distance[client] > (g_dist_leet_weird * 1.05))
					{
						PostThinkPost(client, ground_frames);
						return;
					}					
						
					g_fLastJumpDistance[client] = g_fJump_Distance[client];
					
					//good?
					if (g_fJump_Distance[client] >= g_dist_good_weird && g_fJump_Distance[client] < g_dist_pro_weird)	
					{
						g_LeetJumpDominating[client]=0;
						PrintToChat(client, "[%cKZ%c] %cWJ: %.2f units [%c%i%c Strafes | %c%.0f%c Pre | %c%.0f%c Height | %c%i%c%c Sync]",MOSSGREEN,WHITE, GRAY,g_fJump_Distance[client],LIMEGREEN, strafes, GRAY, LIMEGREEN, g_fPreStrafe[client], GRAY, LIMEGREEN,fJump_Height,GRAY, LIMEGREEN, sync,PERCENT,GRAY);	
						PrintToConsole(client, "        ");
						PrintToConsole(client, "[KZ] %s jumped %0.4f units with a WeirdJump [%i Strafes | %.3f Pre | %.3f Max | Height %.1f | %i%c Sync]",szName, g_fJump_Distance[client],strafes, g_fPreStrafe[client], g_fMaxSpeed2[client],fJump_Height,sync,PERCENT);						
						PrintToConsole(client, "%s", szStrafeStats);	
					}	
					//pro?
					else
						if (g_fJump_Distance[client] >= g_dist_pro_weird && g_fJump_Distance[client] < g_dist_leet_weird)
						{
							g_LeetJumpDominating[client]=0;
							//Client
							PrintToConsole(client, "        ");
							PrintToChat(client, "[%cKZ%c] %cWJ%c: %c%.2f units%c [%c%i%c Strafes | %c%0.f%c Pre | %c%0.f%c Max | %c%.0f%c Height | %c%i%c%c Sync]",MOSSGREEN,WHITE,GREEN,GRAY,GREEN,g_fJump_Distance[client],GRAY,LIMEGREEN,strafes,GRAY,LIMEGREEN,g_fPreStrafe[client],GRAY,LIMEGREEN, g_fMaxSpeed2[client],GRAY,LIMEGREEN,fJump_Height,GRAY, LIMEGREEN, sync,PERCENT,GRAY);
							PrintToConsole(client, "[KZ] %s jumped %0.4f units with a WeirdJump [%i Strafes | %.3f Pre | %.3f Max | Height %.1f | %i%c Sync]",szName, g_fJump_Distance[client],strafes, g_fPreStrafe[client], g_fMaxSpeed2[client],fJump_Height,sync,PERCENT);						
							PrintToConsole(client, "%s", szStrafeStats);
							decl String:buffer[255];
							Format(buffer, sizeof(buffer), "play %s", PROJUMP_RELATIVE_SOUND_PATH); 
							if (g_bEnableQuakeSounds[client])
								ClientCommand(client, buffer); 
							PlayQuakeSound_Spec(client,buffer);	
							//all
							for (new i = 1; i <= MaxClients; i++)
							{
								if (1 <= i <= MaxClients && IsClientInGame(i))
								{
									if (g_bColorChat[i]==true && i != client)
										PrintToChat(i, "%t", "Jumpstats_WeirdAll",MOSSGREEN,WHITE,GREEN,szName, MOSSGREEN,GREEN, g_fJump_Distance[client],MOSSGREEN,GREEN);
								}
							}
						}
						//leet?
						else
							if (g_fJump_Distance[client] >= g_dist_leet_weird)	
							{
								g_LeetJumpDominating[client]++;
								//Client
								PrintToConsole(client, "        ");
								PrintToChat(client, "[%cKZ%c] %cWJ%c: %c%.2f units%c [%c%i%c Strafes | %c%0.f%c Pre | %c%0.f%c Max | %c%.0f%c Height | %c%i%c%c Sync]",MOSSGREEN,WHITE,DARKRED,GRAY,DARKRED,g_fJump_Distance[client],GRAY,LIMEGREEN,strafes,GRAY,LIMEGREEN,g_fPreStrafe[client],GRAY,LIMEGREEN, g_fMaxSpeed2[client],GRAY,LIMEGREEN,fJump_Height,GRAY, LIMEGREEN, sync,PERCENT,GRAY);
								PrintToConsole(client, "[KZ] %s jumped %0.4f units with a WeirdJump [%i Strafes | %.3f Pre | %.3f Max | Height %.1f | %i%c Sync]",szName, g_fJump_Distance[client],strafes, g_fPreStrafe[client], g_fMaxSpeed2[client],fJump_Height,sync,PERCENT);
								PrintToConsole(client, "%s", szStrafeStats);
								if (g_LeetJumpDominating[client]==3)
									PrintToChat(client, "%t", "Jumpstats_OnRampage",MOSSGREEN,WHITE,YELLOW,szName);
								else
									if (g_LeetJumpDominating[client]==5)
										PrintToChat(client, "%t", "Jumpstats_IsDominating",MOSSGREEN,WHITE,YELLOW,szName);
													
								//all
								for (new i = 1; i <= MaxClients; i++)
								{
									if (1 <= i <= MaxClients && IsClientInGame(i))
									{
										if (g_bColorChat[i]==true && i != client)
										{
											PrintToChat(i, "%t", "Jumpstats_WeirdAll",MOSSGREEN,WHITE,DARKRED,szName, RED,DARKRED, g_fJump_Distance[client],RED,DARKRED);
											if (g_LeetJumpDominating[client]==3)
													PrintToChat(i, "%t", "Jumpstats_OnRampage",MOSSGREEN,WHITE,YELLOW,szName);
												else
												if (g_LeetJumpDominating[client]==5)
													PrintToChat(i, "%t", "Jumpstats_IsDominating",MOSSGREEN,WHITE,YELLOW,szName);
										}
									}
								}
								PlayLeetJumpSound(client);
								if (g_LeetJumpDominating[client] != 3 && g_LeetJumpDominating[client] != 5)
								{
									decl String:buffer[255];
									Format(buffer, sizeof(buffer), "play %s", LEETJUMP_RELATIVE_SOUND_PATH); 	
									PlayQuakeSound_Spec(client,buffer);
								}								
							}		
								else
									g_LeetJumpDominating[client]=0;		
					
					//strafesync chat
					if (g_bStrafeSync[client]  && g_fJump_Distance[client] >= g_dist_good_weird)
						PrintToChat(client,"%s", szStrafeSync);	
						
					//new best
					if (g_fPersonalWjRecord[client] < g_fJump_Distance[client]  &&  !IsFakeClient(client))
					{
						if (g_fPersonalWjRecord[client] > 0.0)
							PrintToChat(client, "%t", "Jumpstats_BeatWjBest",MOSSGREEN,WHITE,YELLOW, g_fJump_Distance[client]);
						g_fPersonalWjRecord[client] = g_fJump_Distance[client];
						db_updateWjRecord(client);
					}
				}
			}
	}

	//StandUp BunnyHop (detection works)
	/*if (ground_frames < 11 && g_last_ground_frames[client] > 10 && fGroundDiff == 0.0 && fJump_Height <= 66.0 && !g_bDropJump[client] && g_bStandUpBhop[client])
	{
		if (g_fPreStrafe[client]>300.0)
			PrintToChat(client, "[%cKZ%c] Your Prestrafe is too high. (%c%.1f%c/%c300.0%c max)",MOSSGREEN,WHITE,RED,g_fPreStrafe[client],WHITE,GREEN,WHITE);
		else
		{
			if (g_fJump_Distance[client] >= 250.0)	
			{
				g_LeetJumpDominating[client]=0;
				PrintToChat(client, "[%cKZ%c] StandUp Bhop: %.2f units [%c%i%c Strafes | %c%.0f%c Pre]",MOSSGREEN,WHITE, g_fJump_Distance[client],MOSSGREEN, strafes, WHITE, MOSSGREEN, g_fPreStrafe[client], WHITE);	
			}					
		}
	}*/
	//BunnyHop
	if (ground_frames < 11 && g_last_ground_frames[client] > 10 && fGroundDiff == 0.0 && fJump_Height <= 66.0 && !g_bDropJump[client] && g_fPreStrafe[client] > 200.0)
	{
			//block invalid bot distances (has something to do with the ground-detection of the replay bot) WORKAROUND
			if ((IsFakeClient(client) && g_fJump_Distance[client] > (g_dist_leet_bhop * 1.05)) || g_fJump_Distance[client] > 400.0)
			{
				PostThinkPost(client, ground_frames);
				return;
			}
			
			if (g_fPreStrafe[client]> g_fMaxBhopPreSpeed)
					PrintToChat(client, "[%cKZ%c] Your Prestrafe is too high. (%c%.3f%c/%c%.1f%c max) %cBhop%c",MOSSGREEN,WHITE,RED,g_fPreStrafe[client],WHITE,GREEN,g_fMaxBhopPreSpeed,WHITE,GRAY,WHITE);
			else
			{	
				g_fLastJumpDistance[client] = g_fJump_Distance[client];
				//good?
				if (g_fJump_Distance[client] >= g_dist_good_bhop && g_fJump_Distance[client] < g_dist_pro_bhop)	
				{
					g_LeetJumpDominating[client]=0;
					PrintToChat(client, "[%cKZ%c] %cBhop: %.2f units [%c%i%c Strafes | %c%.0f%c Pre | %c%.0f%c Height | %c%i%c%c Sync]",MOSSGREEN,WHITE,GRAY, g_fJump_Distance[client],LIMEGREEN, strafes, GRAY, LIMEGREEN, g_fPreStrafe[client], GRAY, LIMEGREEN, fJump_Height,GRAY, LIMEGREEN, sync,PERCENT,GRAY);	
					PrintToConsole(client, "        ");
					PrintToConsole(client, "[KZ] %s jumped %0.4f units with a Bhop [%i Strafes | %.3f Pre | %.3f Max | Height %.1f | %i%c Sync]",szName, g_fJump_Distance[client],strafes, g_fPreStrafe[client], g_fMaxSpeed2[client],fJump_Height,sync,PERCENT);						
					PrintToConsole(client, "%s", szStrafeStats);
				}	
				else
					//pro?
					if (g_fJump_Distance[client] >= g_dist_pro_bhop && g_fJump_Distance[client] < g_dist_leet_bhop)
					{
						g_LeetJumpDominating[client]=0;
						//Client
						PrintToConsole(client, "        ");
						PrintToChat(client, "[%cKZ%c] %cBhop%c: %c%.2f units%c [%c%i%c Strafes | %c%0.f%c Pre | %c%0.f%c Max | %c%.0f%c Height | %c%i%c%c Sync]",MOSSGREEN,WHITE,GREEN,GRAY,GREEN,g_fJump_Distance[client],GRAY,LIMEGREEN,strafes,GRAY,LIMEGREEN,g_fPreStrafe[client],GRAY,LIMEGREEN, g_fMaxSpeed2[client],GRAY,LIMEGREEN, fJump_Height,GRAY, LIMEGREEN, sync,PERCENT,GRAY);
						PrintToConsole(client, "[KZ] %s jumped %0.4f units with a Bhop [%i Strafes | %.3f Pre | %.3f Max | Height %.1f | %i%c Sync]",szName, g_fJump_Distance[client],strafes, g_fPreStrafe[client], g_fMaxSpeed2[client],fJump_Height, sync,PERCENT);						
						PrintToConsole(client, "%s", szStrafeStats);
						decl String:buffer[255];
						Format(buffer, sizeof(buffer), "play %s", PROJUMP_RELATIVE_SOUND_PATH); 
						if (g_bEnableQuakeSounds[client])
							ClientCommand(client, buffer); 
						PlayQuakeSound_Spec(client,buffer);	
						//all
						for (new i = 1; i <= MaxClients; i++)
						{
							if (1 <= i <= MaxClients && IsClientInGame(i))
							{
								if (g_bColorChat[i]==true && i != client)
									PrintToChat(i, "%t", "Jumpstats_BhopAll",MOSSGREEN,WHITE,GREEN,szName, MOSSGREEN,GREEN, g_fJump_Distance[client],MOSSGREEN,GREEN);
							}
						}
					}
					else
						//leet?
						if (g_fJump_Distance[client] >= g_dist_leet_bhop)	
						{
							g_LeetJumpDominating[client]++;
							//Client
							PrintToConsole(client, "        ");
							PrintToChat(client, "[%cKZ%c] %cBhop%c: %c%.2f units%c [%c%i%c Strafes | %c%0.f%c Pre | %c%0.f%c Max | %c%.0f%c Height | %c%i%c%c Sync]",MOSSGREEN,WHITE,DARKRED,GRAY,DARKRED,g_fJump_Distance[client],GRAY,LIMEGREEN,strafes,GRAY,LIMEGREEN,g_fPreStrafe[client],GRAY,LIMEGREEN, g_fMaxSpeed2[client],GRAY,LIMEGREEN, fJump_Height,GRAY, LIMEGREEN, sync,PERCENT,GRAY);
							PrintToConsole(client, "[KZ] %s jumped %0.4f units with a Bhop [%i Strafes | %.3f Pre | %.3f Max | Height %.1f | %i%c Sync]",szName, g_fJump_Distance[client],strafes, g_fPreStrafe[client], g_fMaxSpeed2[client],fJump_Height, sync,PERCENT);
							PrintToConsole(client, "%s", szStrafeStats);
							if (g_LeetJumpDominating[client]==3)
								PrintToChat(client, "%t", "Jumpstats_OnRampage",MOSSGREEN,WHITE,YELLOW,szName);
							else
							if (g_LeetJumpDominating[client]==5)
										PrintToChat(client, "%t", "Jumpstats_IsDominating",MOSSGREEN,WHITE,YELLOW,szName);
											
							//all
							for (new i = 1; i <= MaxClients; i++)
							{
								if (1 <= i <= MaxClients && IsClientInGame(i))
								{
									if (g_bColorChat[i]==true && i != client)
									{
										PrintToChat(i, "%t", "Jumpstats_BhopAll",MOSSGREEN,WHITE,DARKRED,szName, RED,DARKRED, g_fJump_Distance[client],RED,DARKRED);
										if (g_LeetJumpDominating[client]==3)
											PrintToChat(i, "%t", "Jumpstats_OnRampage",MOSSGREEN,WHITE,YELLOW,szName);
										else
											if (g_LeetJumpDominating[client]==5)
												PrintToChat(i, "%t", "Jumpstats_IsDominating",MOSSGREEN,WHITE,YELLOW,szName);
									}
								}
							}
							PlayLeetJumpSound(client);
							if (g_LeetJumpDominating[client] != 3 && g_LeetJumpDominating[client] != 5)
							{
								decl String:buffer[255];
								Format(buffer, sizeof(buffer), "play %s", LEETJUMP_RELATIVE_SOUND_PATH); 	
								PlayQuakeSound_Spec(client,buffer);
							}						
						}		
						else
							g_LeetJumpDominating[client]=0;
							
				//strafe sync chat
				if (g_bStrafeSync[client] && g_fJump_Distance[client] >= g_dist_good_bhop)
						PrintToChat(client,"%s", szStrafeSync);		
				
				//new best
				if (g_fPersonalBhopRecord[client] < g_fJump_Distance[client]  &&  !IsFakeClient(client))
				{
					if (g_fPersonalBhopRecord[client] > 0.0)
						PrintToChat(client, "%t", "Jumpstats_BeatBhopBest",MOSSGREEN,WHITE,YELLOW, g_fJump_Distance[client]);
					g_fPersonalBhopRecord[client] = g_fJump_Distance[client];
					db_updateBhopRecord(client);
				}
			}
	}
	PostThinkPost(client, ground_frames);						
}

public PostThinkPost(client, ground_frames)
{
	g_bPlayerJumped[client] = false;
	g_last_ground_frames[client] = ground_frames;		
}

public OnEntityCreated(iEntity, const String:classname[]) 
{ 
	if (1 <= iEntity <= MaxClients && IsClientInGame(iEntity) && !IsFakeClient(iEntity))
	{	
		if(StrEqual(classname, "player"))   
		{
			SDKHook(iEntity, SDKHook_StartTouch, OnTouch);
			SDKHook(iEntity, SDKHook_EndTouch, OnEndTouch);
		}
	}
}

public OnTouch(client, other)
{
	if (IsClientInGame(client) && IsPlayerAlive(client) && !IsFakeClient(client))
	{
		if ((1 <= client <= MaxClients))
		{
			g_bTouchWall[client] = true;
			
			if (!(GetEntityFlags(client) & FL_ONGROUND))
				g_bCheckSurf[client] = true;
		}
	}
}  

public OnEndTouch(client, other)
{
	if (IsClientInGame(client) && IsPlayerAlive(client) && !IsFakeClient(client))
	{
		if ((1 <= client <= MaxClients))
			g_bTouchWall[client] = false;
	}
}  