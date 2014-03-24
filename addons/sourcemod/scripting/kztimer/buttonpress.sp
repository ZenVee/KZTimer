// buttonpress.sp

public ButtonPress(const String:name[], caller, activator, Float:delay)
{
	if(!IsValidEntity(caller) || !IsValidEntity(activator))
		return;
	decl String:targetname[128];
	GetEdictClassname(activator,targetname, sizeof(targetname));
	if(!StrEqual(targetname,"player"))
		return;
	GetEntPropString(caller, Prop_Data, "m_iName", targetname, sizeof(targetname));
	if(StrEqual(targetname,"climb_startbutton"))
	{
		Call_StartForward(hStartPress);
		Call_PushCell(activator);
		Call_Finish();
	} 
	else if(StrEqual(targetname,"climb_endbutton")) 
	{
		Call_StartForward(hEndPress);
		Call_PushCell(activator);
		Call_Finish();
	}
}

// - created Climb buttons -
public OnUsePost(entity, activator, caller, UseType:type, Float:value)
{
	if(!IsValidEntity(entity) || !IsValidEntity(activator))
		return;
		
	decl String:targetname[128];
	GetEdictClassname(activator,targetname, sizeof(targetname));
	if(!StrEqual(targetname,"player"))
		return;
	GetEntPropString(entity, Prop_Data, "m_iName", targetname, sizeof(targetname));
	decl String:buffer[255];
	
	Format(buffer, sizeof(buffer), "play %s", RELATIVE_BUTTON_PATH); 
	if(StrEqual(targetname,"climb_startbutton"))
	{		
		ClientCommand(activator, buffer); 
		Call_StartForward(hStartPress);
		Call_PushCell(activator);
		Call_Finish();
	} 
	else if(StrEqual(targetname,"climb_endbutton")) 
	{
		ClientCommand(activator, buffer); 
		Call_StartForward(hEndPress);
		Call_PushCell(activator);
		Call_Finish();
	}
}  

// - Climb Button OnStartPress -
public CL_OnStartTimerPress(client)
{
	new Float:time;
	time = GetEngineTime() - g_fLastTimeNoClipUsed[client];

	//start recording
	if (!IsFakeClient(client) && g_bReplayBot)
	{
		if (!IsPlayerAlive(client) || GetClientTeam(client) == 1)
		{
			if(g_hRecording[client] != INVALID_HANDLE)
				StopRecording(client);
		}
		else
		{	
			if(g_hRecording[client] != INVALID_HANDLE)
				StopRecording(client);
			StartRecording(client);
		}
	}			
	if (!g_bSpectate[client] && !g_bNoClip[client] && time > 2.0) 
	{	
		//replay bot: play start sound for specs
		if (IsFakeClient(client) && g_bReplayBot)
		{
			for(new i = 1; i <= MaxClients; i++) 
			{
				if (IsClientInGame(i) && !IsPlayerAlive(i))
				{			
					new SpecMode = GetEntProp(i, Prop_Send, "m_iObserverMode");
					if (SpecMode == 4 || SpecMode == 5)
					{		
						new Target = GetEntPropEnt(i, Prop_Send, "m_hObserverTarget");	
						if (Target == client)
						{
							decl String:szsound[255];
							Format(szsound, sizeof(szsound), "play %s", RELATIVE_BUTTON_PATH); 
							ClientCommand(i,szsound);
						}
					}					
				}
			}
		}
		g_fPlayerCordsUndoTp[client][0] = 0.0;
		g_fPlayerCordsUndoTp[client][1] = 0.0;
		g_fPlayerCordsUndoTp[client][2] = 0.0;		
		g_CurrentCp[client] = -1;
		g_CounterCp[client] = 0;	
		g_OverallCp[client] = 0;
		g_OverallTp[client] = 0;
		g_fPauseTime[client] = 0.0;
		g_fStartPauseTime[client] = 0.0;
		g_bRestartCords[client] = true;
		g_bPause[client] = false;
		SetEntityMoveType(client, MOVETYPE_WALK);
		SetEntityRenderMode(client, RENDER_NORMAL);
		g_fStartTime[client] = GetEngineTime();
		g_bMenuOpen[client] = false;		
		g_bTopMenuOpen[client] = false;	
		g_bTimeractivated[client] = true;	
		g_bAutoBhopWasActive[client] = false;
		
		//valid players
		if (!IsFakeClient(client))
		{	
			//Get start position
			GetClientAbsOrigin(client, g_fPlayerCordsRestart[client]);
			GetClientEyeAngles(client, g_fPlayerAnglesRestart[client]);		

			//get steamid
			decl String:szSteamId[32];
			GetClientAuthString(client, szSteamId, 32);
			
			//set tmp record (insert/update just after the 1st button press on a map, spam protection)
			db_setTmpDataRecord(client, szSteamId, g_szMapName);
			
			//star message
			decl String:szTpTime[32];
			decl String:szProTime[32];
			if (g_fPersonalRecord[client]<=0.0)
					Format(szTpTime, 32, "NONE");
			else
			{
				FormatTimeFloat(client, g_fPersonalRecord[client], 3);
				Format(szTpTime, 32, "%s (#%i/%i)", g_szTime[client],g_maprank_tp[client],g_maptimes_tp);
			}
			if (g_fPersonalRecordPro[client]<=0.0)
					Format(szProTime, 32, "NONE");
			else
			{
				FormatTimeFloat(client, g_fPersonalRecordPro[client], 3);
				Format(szProTime, 32, "%s (#%i/%i)", g_szTime[client],g_maprank_pro[client],g_maptimes_pro);
			}
			
			CreateTimer(2.5, OverlayTimer, client,TIMER_FLAG_NO_MAPCHANGE);
			g_bOverlay[client]=true;
			if (g_bTimeractivated[client] == true)
					PrintHintText(client,"Timer restarted\nPro: %s\nTP: %s", szProTime,szTpTime);
			else
				PrintHintText(client,"Timer started\nPro: %s\nTP: %s", szProTime,szTpTime);	
		}	
	}
}

// - Climb Button OnEndPress -
public CL_OnEndTimerPress(client)
{
	if (!g_bTimeractivated[client]) 
		return;	
	g_bTimeractivated[client] = false;	
	//Format Final Time
	if (IsFakeClient(client))
	{
		for(new i = 1; i <= MaxClients; i++) 
		{
			if (IsClientInGame(i) && !IsPlayerAlive(i))
			{			
				new SpecMode = GetEntProp(i, Prop_Send, "m_iObserverMode");
				if (SpecMode == 4 || SpecMode == 5)
				{		
					new Target = GetEntPropEnt(i, Prop_Send, "m_hObserverTarget");	
					if (Target == client)
					{
						if (Target == g_iBot2)
							PrintToChat(i, "%t", "ReplayFinishingMsg", MOSSGREEN,GRAY,LIMEGREEN,g_szReplayNameTp,GRAY,LIMEGREEN,g_szReplayTimeTp,GRAY);
						else
						if (Target == g_iBot)
							PrintToChat(i, "%t", "ReplayFinishingMsg", MOSSGREEN,GRAY,LIMEGREEN,g_szReplayName,GRAY,LIMEGREEN,g_szReplayTime,GRAY);
						decl String:szsound[255];
						Format(szsound, sizeof(szsound), "play %s", RELATIVE_BUTTON_PATH); 
						ClientCommand(i,szsound);
					}
				}					
			}		
		}	
		return;
	}
	
	//decl
	decl String:szName[MAX_NAME_LENGTH];	
	decl String:szNameOpponent[MAX_NAME_LENGTH];	
	decl String:szSteamIdOpponent[32];
	decl String:szSteamId[32];
	new teleports = g_OverallTp[client];
	new bool:hasRecord;
	new Float: difference;
	g_record_type[client] = -1;
	g_sound_type[client] = -1;
	g_bMapRankToChat[client] = true;
	if (!IsClientInGame(client))
		return;	
	GetClientAuthString(client, szSteamId, 32);
	GetClientName(client, szName, MAX_NAME_LENGTH);
	
	//Final time
	g_fFinalTime[client] = GetEngineTime() - g_fStartTime[client] - g_fPauseTime[client];			
	FormatTimeFloat(client, g_fFinalTime[client], 3);
	Format(g_szNewTime[client], 32, "%s", g_szTime[client]);	
	
	//Info msg: Chat msg can be a bit delayed if too many db requests
	CreateTimer(2.5, OverlayTimer, client,TIMER_FLAG_NO_MAPCHANGE);
	g_bOverlay[client]=true;
	PrintHintText(client,"Timer stopped.\nYou finished the map in: %s!\nCongratulations.", g_szNewTime[client]);
	
	//calc difference
	if (g_OverallTp[client]==0)
	{
		g_pr_multiplier[client]+=4;
		if (g_fPersonalRecordPro[client] > 0.0)
		{
			hasRecord=true;
			difference = g_fPersonalRecordPro[client] - g_fFinalTime[client];
			FormatTimeFloat(client, difference, 3);
		}
		else
			g_pr_finishedmaps_pro[client]++;
		
	}
	else
	{
		g_pr_multiplier[client]+=3;
		if (g_fPersonalRecord[client] > 0.0 && g_OverallTp[client] > 0)
		{
			hasRecord=true;
			difference = g_fPersonalRecord[client]-g_fFinalTime[client];
			FormatTimeFloat(client, difference, 3);
		}	
		else
			g_pr_finishedmaps_tp[client]++;			
	}
	if (hasRecord)
	{
		if (difference > 0.0)
			Format(g_szTimeDifference[client], 32, "-%s", g_szTime[client]);
		else
			Format(g_szTimeDifference[client], 32, "+%s", g_szTime[client]);
	}
	
	//Type of time
	if (!hasRecord)
	{
		if (g_OverallTp[client]>0)
		{
			g_time_type[client] = 0;
			g_maptimes_tp++;
		}
		else
		{
			g_time_type[client] = 1;
			g_maptimes_pro++;
		}
	}
	else
	{
		if (difference> 0.0)
		{
			if (g_OverallTp[client]>0)
				g_time_type[client] = 2;
			else
				g_time_type[client] = 3;
		}
		else
		{
			if (g_OverallTp[client]>0)
				g_time_type[client] = 4;
			else
				g_time_type[client] = 5;
		}
	}
	
	//NEW GLOBAL RECORD 
	if (!g_bMapButtons && g_bBhopHackProtection && g_bglobalValidFilesize && g_BGlobalDBConnected && g_hDbGlobal != INVALID_HANDLE && g_bEnforcer && !g_bAutoBhopWasActive[client]) 
	{
		if (g_btickrate64 && g_fFinalTime[client] < g_fRecordTimeGlobal)
		{
			g_fRecordTimeGlobal = g_fFinalTime[client];
			Format(g_szRecordGlobalPlayer, MAX_NAME_LENGTH, "%s", szName);	
			g_pr_multiplier[client]+= 6;
			g_record_type[client] = 3;
			g_sound_type[client] = 1;	
		}
		else
		{
			if (!g_btickrate64 && g_fFinalTime[client] < g_fRecordTimeGlobal128)
			{
				g_fRecordTimeGlobal128 = g_fFinalTime[client];
				Format(g_szRecordGlobalPlayer128, MAX_NAME_LENGTH, "%s", szName);	
				g_pr_multiplier[client]+= 6;
				g_record_type[client] = 4;
				g_sound_type[client] = 1;	
			}
		}	
	}
	
	//NEW PRO RECORD
	if((g_fFinalTime[client] < g_fRecordTimePro) && g_OverallTp[client] <= 0)
	{
		g_pr_multiplier[client]+= 5;
		if (g_record_type[client] != 3 && g_record_type[client] != 4)
			g_record_type[client] = 2;
		g_fRecordTimePro = g_fFinalTime[client]; 
		Format(g_szRecordPlayerPro, MAX_NAME_LENGTH, "%s", szName);
		if (g_sound_type[client] != 1)
			g_sound_type[client] = 2;
			
		//save replay	
		if (g_bReplayBot)
			CreateTimer(3.0, ProReplayTimer, client,TIMER_FLAG_NO_MAPCHANGE);
	} 
	
	//NEW TP RECORD
	if((g_fFinalTime[client] < g_fRecordTime) && g_OverallTp[client] > 0)
	{
		g_pr_multiplier[client]+=4;
		if (g_record_type[client] != 3 && g_record_type[client] != 4)
			g_record_type[client] = 1;
		g_fRecordTime = g_fFinalTime[client];
		Format(g_szRecordPlayer, MAX_NAME_LENGTH, "%s", szName);
		//g_RecordTps = g_OverallTp[client];
		if (g_sound_type[client] != 1)
			g_sound_type[client] = 3;
		//save replay	
		if (g_bReplayBot)
			CreateTimer(3.0, TpReplayTimer, client,TIMER_FLAG_NO_MAPCHANGE);
			
	}
			
	//Challenge
	if (g_bChallenge[client])
	{
		SetEntityRenderColor(client, 255,255,255,255);		
		for (new i = 1; i <= MaxClients; i++)
		{
			if (IsClientInGame(i) && i != client && i != g_iBot && i != g_iBot2)
			{	
				GetClientAuthString(i, szSteamIdOpponent, 32);		
				if (StrEqual(szSteamIdOpponent,g_szCOpponentID[client]))
				{	
					g_bChallenge[client]=false;
					g_bChallenge[i]=false;
					SetEntityRenderColor(i, 255,255,255,255);
					db_insertPlayerChallenge(client);
					GetClientName(i, szNameOpponent, MAX_NAME_LENGTH);	
					for (new k = 1; k <= MaxClients; k++)
							if (1 <= k <= MaxClients && IsClientInGame(k) && IsValidEntity(k))
								PrintToChat(k, "%t", "ChallengeW", RED,WHITE,MOSSGREEN,szName,WHITE,MOSSGREEN,szNameOpponent,WHITE); 			
					g_challenge_win_ratio[client]++;	
					g_challenge_win_ratio[i]--;		
					if (g_CBet[client]>0)
					{
						g_challenge_points_ratio[client] += g_CBet[client] * g_pr_points_finished;
						g_challenge_points_ratio[i] -= g_CBet[i] * g_pr_points_finished;
						g_pr_multiplier[client]+= g_CBet[client];
						g_pr_multiplier[i] -= g_CBet[client];								
						g_pr_showmsg[i] = true;
						new lostpoints = g_CBet[client] * g_pr_points_finished;
						for (new j = 1; j <= MaxClients; j++)
							if (1 <= j <= MaxClients && IsClientInGame(j) && IsValidEntity(j))
								PrintToChat(j, "%t", "ChallengeL", MOSSGREEN, WHITE, PURPLE,szNameOpponent, GRAY, RED, lostpoints,GRAY);			
					}
					CreateTimer(0.0, RefreshPoints, client,TIMER_FLAG_NO_MAPCHANGE);
					CreateTimer(1.0, RefreshPoints, i,TIMER_FLAG_NO_MAPCHANGE);
					g_pr_showmsg[i]=true;
					i = MaxClients;
				}
			}
		}		
	}
	
	//set mvp star
	g_MVPStars[client] += 1;
	CS_SetMVPCount(client,g_MVPStars[client]);		
	
	g_pr_showmsg[client] = true;
	
	//local db update
	if ((g_fFinalTime[client] < g_fPersonalRecord[client] && teleports > 0 || g_fPersonalRecord[client] <= 0.0 && teleports > 0) || (g_fFinalTime[client] < g_fPersonalRecordPro[client] && teleports == 0 || g_fPersonalRecordPro[client] <= 0.0 && teleports == 0))
	{
		g_pr_multiplier[client]++;
		db_selectRecord(client);
	}
	else
	{
		if (g_OverallTp[client] > 0)
			db_viewMapRankTp(client);
		else
			db_viewMapRankPro(client);
	}
	
	//global db update
	if (!g_bMapButtons && g_bGlobalDB && g_BGlobalDBConnected && g_hDbGlobal != INVALID_HANDLE && g_bEnforcer && g_bBhopHackProtection && g_bglobalValidFilesize && !g_bAutoTimer && !g_bAutoBhopWasActive[client])	
		db_GlobalRecord(client);
	else
	{
		if (g_hDbGlobal == INVALID_HANDLE || !g_BGlobalDBConnected)
			PrintToConsole(client, "[KZ] Global Records disabled. Reason: No connection to the global database.");
		else
			if (g_bMapButtons)
				PrintToConsole(client, "[KZ] Global Records disabled. Reason: Only maps with integrated climb buttons are supported.");
			else
				if (!g_bEnforcer)
					PrintToConsole(client, "[KZ] Global Records disabled. Reason: Server settings enforcer disabled.");
				else
					if (!g_bglobalValidFilesize)
						PrintToConsole(client, "[KZ] Global Records disabled. Reason: Wrong .bsp file size. (other version registered in the global database. please contact an admin)");	
					else
						if (!g_bBhopHackProtection)
							PrintToConsole(client, "[KZ] Global Records disabled. Reason: KZ AntiCheat disabled.");
						else
							if (g_bAutoTimer)
								PrintToConsole(client, "[KZ] Global Records disabled. Reason: kz_auto_timer enabled.");
							else
								if (g_bAutoBhopWasActive[client])
									PrintToConsole(client, "[KZ] Global Records disabled. Reason: kz_auto_bhop was enabled during your run.");								
	}
}