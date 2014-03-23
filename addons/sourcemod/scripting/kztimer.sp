#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <dhooks>
#include <adminmenu>
#include <cstrike>
#include <button>
#include <entity>
#include <setname>
#include <smlib>
#include <geoip>
#include <colors>
#undef REQUIRE_EXTENSIONS
#define VERSION "1.11 Nightly#2"
#define ADMIN_LEVEL ADMFLAG_UNBAN
#define WHITE 0x01
#define DARKRED 0x02
#define PURPLE 0x03
#define GREEN 0x04
#define MOSSGREEN 0x05
#define LIMEGREEN 0x06
#define RED 0x07
#define GRAY 0x08
#define YELLOW 0x09
#define QUOTE 0x22
#define PERCENT 0x25
#define CPLIMIT 30 
#define MYSQL 0
#define SQLITE 1
#define MAX_MAP_LENGTH 128
#define MAX_BUTTONS 25
#define HIDE_RADAR ( 1<<12 )
#define HIDE_ROUNDTIME ( 1<<13 )
#define ASSISTS_OFFSET_FROM_FRAGS 4 
#define MAX_MAPS 1000
#define MAX_PR_PLAYERS 10000
#define MAX_STRAFES 100

//botmimic2
#define MAX_RECORD_NAME_LENGTH 64
#define BM_MAGIC 0xBAADF00D
#define BINARY_FORMAT_VERSION 0x01
#define ADDITIONAL_FIELD_TELEPORTED_ORIGIN (1<<0)
#define ADDITIONAL_FIELD_TELEPORTED_ANGLES (1<<1)
#define ADDITIONAL_FIELD_TELEPORTED_VELOCITY (1<<2)
#define FRAME_INFO_SIZE 15
#define FRAME_INFO_SIZE_V1 14
#define AT_SIZE 10
#define AT_ORIGIN 0
#define AT_ANGLES 1
#define AT_VELOCITY 2
#define AT_FLAGS 3
#define ORIGIN_SNAPSHOT_INTERVAL 250
#define FILE_HEADER_LENGTH 74

//botmimic 2
enum FrameInfo 
{
	playerButtons = 0,
	playerImpulse,
	Float:actualVelocity[3],
	Float:predictedVelocity[3],
	Float:predictedAngles[2], 
	CSWeaponID:newWeapon,
	playerSubtype,
	playerSeed,
	additionalFields, 
	pause, 
}

enum AdditionalTeleport 
{
	Float:atOrigin[3],
	Float:atAngles[3],
	Float:atVelocity[3],
	atFlags
}

enum FileHeader 
{
	FH_binaryFormatVersion = 0,
	String:FH_Time[32],
	String:FH_Playername[32],
	FH_Checkpoints,
	FH_tickCount,
	Float:FH_initialPosition[3],
	Float:FH_initialAngles[3],
	Handle:FH_frames
}

enum VelocityOverride
{
	VelocityOvr_None = 0,
	VelocityOvr_Velocity,
	VelocityOvr_OnlyWhenNegative,
	VelocityOvr_InvertReuseVelocity
}

//global declarations
new g_i = 0;
new g_DbType;
new g_ReplayRecordTps;
new Handle:g_hAdminMenu;
new Handle:g_hTeleport;
new Handle:g_MapList = INVALID_HANDLE;
new Handle:g_hDb = INVALID_HANDLE;
new Handle:g_hDbGlobal = INVALID_HANDLE;
new Handle:hStartPress = INVALID_HANDLE;
new Handle:hEndPress = INVALID_HANDLE;
new Handle:g_hclimbersmenu[MAXPLAYERS+1] = INVALID_HANDLE;
new Handle:g_hTopJumpersMenu[MAXPLAYERS+1] = INVALID_HANDLE;

//cvars
new Handle:g_hWelcomeMsg = INVALID_HANDLE;
new String:g_sWelcomeMsg[512];  
new Handle:g_hReplayBotPlayerModel = INVALID_HANDLE;
new String:g_sReplayBotPlayerModel[256];  
new Handle:g_hReplayBotArmModel = INVALID_HANDLE;
new String:g_sReplayBotArmModel[256];  
new Handle:g_hPlayerModel = INVALID_HANDLE;
new String:g_sPlayerModel[256];  
new Handle:g_hArmModel = INVALID_HANDLE;
new String:g_sArmModel[256];  
new Handle:g_hdist_good_weird = INVALID_HANDLE;
new Float:g_dist_good_weird;
new Handle:g_hdist_pro_weird = INVALID_HANDLE;
new Float:g_dist_pro_weird;
new Handle:g_hdist_leet_weird = INVALID_HANDLE;
new Float:g_dist_leet_weird;
new Handle:g_hdist_good_dropbhop = INVALID_HANDLE;
new Float:g_dist_good_dropbhop;
new Handle:g_hdist_pro_dropbhop = INVALID_HANDLE;
new Float:g_dist_pro_dropbhop;
new Handle:g_hdist_leet_dropbhop = INVALID_HANDLE;
new Float:g_dist_leet_dropbhop;
new Handle:g_hdist_good_bhop = INVALID_HANDLE;
new Float:g_dist_good_bhop;
new Handle:g_hdist_pro_bhop = INVALID_HANDLE;
new Float:g_dist_pro_bhop;
new Handle:g_hdist_leet_bhop = INVALID_HANDLE;
new Float:g_dist_leet_bhop;
new Handle:g_hdist_good_multibhop = INVALID_HANDLE;
new Float:g_dist_good_multibhop;
new Handle:g_hdist_pro_multibhop = INVALID_HANDLE;
new Float:g_dist_pro_multibhop;
new Handle:g_hdist_leet_multibhop = INVALID_HANDLE;
new Float:g_dist_leet_multibhop;
new Handle:g_hdist_good_lj = INVALID_HANDLE;
new Float:g_dist_good_lj;
new Handle:g_hdist_pro_lj = INVALID_HANDLE;
new Float:g_dist_pro_lj;
new Handle:g_hdist_leet_lj = INVALID_HANDLE;
new Float:g_dist_leet_lj;
new Handle:g_hBhopSpeedCap = INVALID_HANDLE;
new Float:g_fBhopSpeedCap;
new Handle:g_hPlayerpointsScale = INVALID_HANDLE;
new Float:g_fPlayerpointsScale = 1.0;
new Handle:g_hMaxBhopPreSpeed = INVALID_HANDLE;
new Float:g_fMaxBhopPreSpeed;
new Handle:g_hcvarRestore = INVALID_HANDLE;
new bool:g_bRestore;
new Handle:g_hNoClipS = INVALID_HANDLE;
new bool:g_bNoClipS;
new Handle:g_hReplayBot = INVALID_HANDLE;
new bool:g_bReplayBot;
new Handle:g_hPauseServerside = INVALID_HANDLE;
new bool:g_bPauseServerside;
new Handle:g_hAutoBhop = INVALID_HANDLE;
new bool:g_bAutoBhop;
new bool:g_bAutoBhop2;
new Handle:g_hRadioCommands = INVALID_HANDLE;
new bool:g_bRadioCommands;
new Handle:g_hGoToServer = INVALID_HANDLE;
new bool:g_bGoToServer;
new Handle:g_hPlayerSkinChange = INVALID_HANDLE;
new bool:g_bPlayerSkinChange;
new Handle:g_hJumpStats = INVALID_HANDLE;
new bool:g_bJumpStats;
new Handle:g_hForceJumpPenalty = INVALID_HANDLE;
new bool:g_bForceJumpPenalty;
new Handle:g_hCountry = INVALID_HANDLE;
new bool:g_bCountry;
new Handle:g_hAutoRespawn = INVALID_HANDLE;
new bool:g_bAutoRespawn;
new Handle:g_hAllowCheckpoints = INVALID_HANDLE;
new bool:g_bAllowCheckpoints;
new Handle:g_hcvarNoBlock = INVALID_HANDLE;
new bool:g_bNoBlock;
new Handle:g_hPointSystem = INVALID_HANDLE;
new bool:g_bPointSystem;
new Handle:g_hCleanWeapons = INVALID_HANDLE;
new bool:g_bCleanWeapons;
new Handle:g_hcvargodmode = INVALID_HANDLE;
new bool:g_bAutoTimer;
new Handle:g_hAutoTimer = INVALID_HANDLE;
new bool:g_bgodmode;
new Handle:g_hEnforcer = INVALID_HANDLE;
new bool:g_bEnforcer;
new Handle:g_hPreStrafe = INVALID_HANDLE;
new bool:g_bPreStrafe;
new Handle:g_hGlobalDB = INVALID_HANDLE;
new bool:g_bGlobalDB;
new Handle:g_hfpsCheck = INVALID_HANDLE;
new bool:g_bfpsCheck;
new Handle:g_hAutohealing_Hp = INVALID_HANDLE;
new g_Autohealing_Hp;

//other decl.
new Float:g_fMapStartTime;
new Float:g_strafe_good_sync[MAXPLAYERS+1][MAX_STRAFES];
new Float:g_strafe_frames[MAXPLAYERS+1][MAX_STRAFES];
new Float:g_strafe_gained[MAXPLAYERS+1][MAX_STRAFES];
new Float:g_strafe_max_speed[MAXPLAYERS+1][MAX_STRAFES];
new Float:g_strafe_lost[MAXPLAYERS+1][MAX_STRAFES];
new Float:g_fStartTime[MAXPLAYERS+1];
new Float:g_fFinalTime[MAXPLAYERS+1];
new Float:g_fPauseTime[MAXPLAYERS+1];
new Float:g_fLastTimeNoClipUsed[MAXPLAYERS+1];
new Float:g_fStartPauseTime[MAXPLAYERS+1];
new Float:g_fPlayerCords[MAXPLAYERS+1][CPLIMIT][3];
new Float:g_fPlayerAngles[MAXPLAYERS+1][CPLIMIT][3];
new Float:g_fPlayerCordsRestart[MAXPLAYERS+1][3]; 
new Float:g_fPlayerAnglesRestart[MAXPLAYERS+1][3]; 
new Float:g_fPlayerCordsRestore[MAXPLAYERS+1][3];
new Float:g_fPlayerAnglesRestore[MAXPLAYERS+1][3];
new Float:g_fPlayerCordsUndoTp[MAXPLAYERS+1][3];
new Float:g_fPlayerAnglesUndoTp[MAXPLAYERS+1][3];
new Float:g_fPosOld[MAXPLAYERS+1][3];
new Float:g_fPersonalRecord[MAXPLAYERS+1];
new Float:g_fPersonalRecordPro[MAXPLAYERS+1];
new Float:g_fRecordTime=9999999.0;
new Float:g_fRecordTimePro=9999999.0;
new Float:g_fRecordTimeGlobal=9999999.0;
new Float:g_fRecordTimeGlobal128=9999999.0;
new Float:g_fRunTime[MAXPLAYERS+1];
new Float:g_fPlayerConnectedTime[MAXPLAYERS+1];
new Float:g_fStartCommandUsed_LastTime[MAXPLAYERS+1];
new Float:g_fLastTime_DBQuery[MAXPLAYERS+1];
new Float:g_fJump_Initial[MAXPLAYERS+1][3];
new Float:g_fJump_InitialLastHeight[MAXPLAYERS+1];
new Float:g_fJump_Final[MAXPLAYERS+1][3];
new Float:g_fJump_DistanceX[MAXPLAYERS+1];
new Float:g_fTakeOffSpeed[MAXPLAYERS+1];
new Float:g_fJump_DistanceZ[MAXPLAYERS+1];
new Float:g_fJump_Distance[MAXPLAYERS+1];
new Float:g_fPreStrafe[MAXPLAYERS+1];
new Float:g_fJumpOffTime[MAXPLAYERS+1];
new Float:g_fDroppedUnits[MAXPLAYERS+1];
new Float:g_fMaxSpeed[MAXPLAYERS+1];
new Float:g_fOldSpeed[MAXPLAYERS+1];
new Float:g_fMaxSpeed2[MAXPLAYERS +1];
new Float:g_flastHeight[MAXPLAYERS +1];
new Float:g_fMaxHeight[MAXPLAYERS+1];
new Float:g_fLastTimeDucked[MAXPLAYERS+1];
new Float:g_fLastJumpTime[MAXPLAYERS+1];
new Float:g_fLastJumpDistance[MAXPLAYERS+1];
new Float:g_fPersonalWjRecord[MAX_PR_PLAYERS]=-1.0;
new Float:g_fPersonalDropBhopRecord[MAX_PR_PLAYERS]=-1.0;
new Float:g_fPersonalBhopRecord[MAX_PR_PLAYERS]=-1.0;
new Float:g_fPersonalMultiBhopRecord[MAX_PR_PLAYERS]=-1.0;
new Float:g_fPersonalLjRecord[MAX_PR_PLAYERS]=-1.0;
new Float:g_PrestrafeVelocity[MAXPLAYERS+1];
new Float:g_fChallengeRequestTime[MAXPLAYERS+1];
new Float:g_fCStartPosition[MAXPLAYERS+1][3]; 
new Float:g_good_sync[MAXPLAYERS+1];
new Float:g_sync_frames[MAXPLAYERS+1];
new Float:g_fLastPosition[MAXPLAYERS + 1][3];
new Float:g_fLastVelocity[MAXPLAYERS + 1];
new Float:g_fLastAngle[MAXPLAYERS + 1];
new Float:g_OldAngle[MAXPLAYERS+1];
new Float:g_pr_finishedmaps_tp_perc[MAX_PR_PLAYERS]; 
new Float:g_pr_finishedmaps_pro_perc[MAX_PR_PLAYERS]; 
new bool:g_bMapButtons;
new bool:g_bglobalValidFilesize;
new bool:g_btickrate64;
new bool:g_bProReplay;
new bool:g_bTpReplay;
new bool:g_pr_refreshingDB;
new bool:g_bCCheckpoints[MAXPLAYERS+1];
new bool:g_bTopMenuOpen[MAXPLAYERS+1]; 
new bool:g_bStandUpBhop[MAXPLAYERS+1];
new bool:g_bDetailView[MAXPLAYERS+1];
new bool:g_bNoClipUsed[MAXPLAYERS+1];
new bool:g_bMenuOpen[MAXPLAYERS+1];
new bool:g_bRestartCords[MAXPLAYERS+1];
new bool:g_bPause[MAXPLAYERS+1];
new bool:g_bOverlay[MAXPLAYERS+1];
new bool:g_bchallengeConnected[MAXPLAYERS+1]=false;
new bool:g_bBhopPluginEnabled;
new bool:g_bBhopHackProtection;
new bool:g_bDuckInAir[MAXPLAYERS+1];
new bool:g_bLastButtonJump[MAXPLAYERS+1];
new bool:g_bPlayerJumped[MAXPLAYERS+1];
new bool:g_bOnGround[MAXPLAYERS+1];
new bool:g_bCheckSurf[MAXPLAYERS+1];
new bool:g_bSpectate[MAXPLAYERS+1];
new bool:g_bTimeractivated[MAXPLAYERS+1];
new bool:g_bFirstSpawn[MAXPLAYERS+1];
new bool:g_bRestoreC[MAXPLAYERS+1]; 
new bool:g_bRestoreCMsg[MAXPLAYERS+1]; 
new bool:g_bClimbersMenuOpen[MAXPLAYERS+1]; 
new bool:g_bClimbersMenuOpen2[MAXPLAYERS+1]; 
new bool:g_bNoClip[MAXPLAYERS+1]; 
new bool:g_bMapFinished[MAXPLAYERS+1]; 
new bool:g_bRespawnPosition[MAXPLAYERS+1]; 
new bool:g_bManualRecalc; 
new bool:g_bSelectProfile[MAXPLAYERS+1]; 
new bool:g_bClimbersMenuwasOpen[MAXPLAYERS+1]; 
new bool:g_bDropJump[MAXPLAYERS+1];    
new bool:g_bInvalidGround[MAXPLAYERS+1];
new bool:g_bChallengeAbort[MAXPLAYERS+1];
new bool:g_bLastInvalidGround[MAXPLAYERS+1];
new bool:g_bMapRankToChat[MAXPLAYERS+1];
new bool:g_bChallenge[MAXPLAYERS+1];
new bool:g_bChallengeRequest[MAXPLAYERS+1];
new bool:g_strafing_aw[MAXPLAYERS+1];
new bool:g_strafing_sd[MAXPLAYERS+1];
new bool:g_pr_showmsg[MAXPLAYERS+1];
new bool:g_bSlowDownCheck[MAXPLAYERS+1];
new bool:g_CMOpen[MAXPLAYERS+1];
new bool:g_bTouchWall[MAXPLAYERS+1];
new bool:g_brc_PlayerRank[MAXPLAYERS+1];
new bool:g_bAutoBhopWasActive[MAXPLAYERS+1];
new bool:g_bColorChat[MAXPLAYERS+1]=true;
new bool:g_BGlobalDBConnected=false;
new bool:g_bInfoPanel[MAXPLAYERS+1]=false;
new bool:g_bClimbersMenuSounds[MAXPLAYERS+1]=true;
new bool:g_bEnableQuakeSounds[MAXPLAYERS+1]=true;
new bool:g_bShowNames[MAXPLAYERS+1]=true; 
new bool:g_bStrafeSync[MAXPLAYERS+1]=false;
new bool:g_bGoToClient[MAXPLAYERS+1]=true; 
new bool:g_bShowTime[MAXPLAYERS+1]=true; 
new bool:g_bHide[MAXPLAYERS+1]=false; 
new bool:g_bShowSpecs[MAXPLAYERS+1]=true; 
new bool:g_bCPTextMessage[MAXPLAYERS+1]=false; 
new bool:g_bAdvancedClimbersMenu[MAXPLAYERS+1]=false;
new bool:g_bAutoBhopClient[MAXPLAYERS+1]=true;
new bool:g_bJumpPenalty[MAXPLAYERS+1]=false;
//org
new bool:g_borg_ColorChat[MAXPLAYERS+1];
new bool:g_borg_InfoPanel[MAXPLAYERS+1];
new bool:g_borg_ClimbersMenuSounds[MAXPLAYERS+1];
new bool:g_borg_EnableQuakeSounds[MAXPLAYERS+1];
new bool:g_borg_ShowNames[MAXPLAYERS+1]; 
new bool:g_borg_StrafeSync[MAXPLAYERS+1];
new bool:g_borg_GoToClient[MAXPLAYERS+1]; 
new bool:g_borg_ShowTime[MAXPLAYERS+1]; 
new bool:g_borg_Hide[MAXPLAYERS+1]; 
new bool:g_borg_ShowSpecs[MAXPLAYERS+1]; 
new bool:g_borg_CPTextMessage[MAXPLAYERS+1]; 
new bool:g_borg_AdvancedClimbersMenu[MAXPLAYERS+1];
new bool:g_borg_AutoBhopClient[MAXPLAYERS+1];
new bool:g_borg_JumpPenalty[MAXPLAYERS+1];
new g_bManualRecalcClientID=-1; 
new g_unique_FileSize;
new g_maptimes_pro;
new g_maptimes_tp;
new g_pr_players;
new g_pr_players2;
new g_pr_mapcount;
new g_iBot=-1;
new g_iBot2=-1;
new ownerOffset;
new g_pr_rank_Novice; 
new g_pr_rank_Scrub; 
new g_pr_rank_Rookie;
new g_pr_rank_Skilled;
new g_pr_rank_Expert;
new g_pr_rank_Pro;
new g_pr_rank_Elite;
new g_pr_rank_Master;
new g_pr_points_finished;
new g_pr_dyn_maxpoints;
new g_pr_rowcount;
new g_pr_row;
new g_pr_points[MAX_PR_PLAYERS];
new g_pr_maprecords_row_counter[MAX_PR_PLAYERS];
new g_pr_maprecords_row_count[MAX_PR_PLAYERS];
new g_pr_oldpoints[MAX_PR_PLAYERS];  
new g_pr_multiplier[MAX_PR_PLAYERS]; 
new g_pr_finishedmaps_tp[MAX_PR_PLAYERS]; 
new g_pr_finishedmaps_pro[MAX_PR_PLAYERS]; 
new g_CBet[MAXPLAYERS+1];
new g_UspDrops[MAXPLAYERS+1];
new g_sync[MAXPLAYERS+1];
new g_maprank_tp[MAXPLAYERS+1];
new g_maprank_pro[MAXPLAYERS+1];
new g_time_type[MAXPLAYERS+1];
new g_sound_type[MAXPLAYERS+1];
new g_tprecords[MAXPLAYERS+1];
new g_prorecords[MAXPLAYERS+1];
new g_record_type[MAXPLAYERS+1];
new g_challenge_win_ratio[MAXPLAYERS+1];
new g_CountdownTime[MAXPLAYERS+1];
new g_challenge_points_ratio[MAXPLAYERS+1];
new g_ground_frames[MAXPLAYERS+1];
new g_CurrentCp[MAXPLAYERS+1];
new g_CounterCp[MAXPLAYERS+1];
new g_OverallCp[MAXPLAYERS+1];
new g_OverallTp[MAXPLAYERS+1];
new g_SpecTarget[MAXPLAYERS+1];
new g_PrestrafeFrameCounter[MAXPLAYERS+1];
new g_mouseDirOld[MAXPLAYERS+1];
new g_BhopRank[MAX_PR_PLAYERS];
new g_MultiBhopRank[MAX_PR_PLAYERS];
new g_LjRank[MAX_PR_PLAYERS];
new g_DropBhopRank[MAX_PR_PLAYERS];
new g_wjRank[MAX_PR_PLAYERS];
new g_LastButton[MAXPLAYERS + 1];
new g_CurrentButton[MAXPLAYERS+1];
new g_strafecount[MAXPLAYERS+1];
new g_Strafes[MAXPLAYERS+1];
new g_MVPStars[MAXPLAYERS+1];
new g_AdminMenuLastPage[MAXPLAYERS+1];
new g_OptionMenuLastPage[MAXPLAYERS+1];
new g_LeetJumpDominating[MAXPLAYERS+1]; 
new g_multi_bhop_count[MAXPLAYERS+1];
new g_last_ground_frames[MAXPLAYERS+1];
new String:g_szMapTag[2][32];  
new String:g_szReplayName[128];  
new String:g_szReplayTime[128]; 
new String:g_szReplayNameTp[128];  
new String:g_szReplayTimeTp[128]; 
new String:g_szCOpponentID[MAXPLAYERS+1][32]; 
new String:g_szTimeDifference[MAXPLAYERS+1][32]; 
new String:g_szNewTime[MAXPLAYERS+1][32];
new String:g_szMapName[MAX_MAP_LENGTH];
new String:g_szMenuTitleRun[MAXPLAYERS+1][255];
new String:g_szTime[MAXPLAYERS+1][32];
new String:g_szRecordGlobalPlayer[MAX_NAME_LENGTH];
new String:g_szRecordGlobalPlayer128[MAX_NAME_LENGTH];
new String:g_szRecordPlayerPro[MAX_NAME_LENGTH];
new String:g_szRecordPlayer[MAX_NAME_LENGTH];
new String:g_szProfileName[MAXPLAYERS+1][MAX_NAME_LENGTH];
new String:g_szPlayerPanelText[MAXPLAYERS+1][512];
new String:g_szProfileSteamId[MAXPLAYERS+1][32];
new String:g_szCountry[MAXPLAYERS+1][100];
new String:g_szCountryCode[MAXPLAYERS+1][16]; 
new String:g_pr_rankname[MAXPLAYERS+1][32];  
new String:g_pr_szrank[MAXPLAYERS+1][512];  
new String:g_pr_szName[MAX_PR_PLAYERS][64];  
new String:g_pr_szSteamID[MAX_PR_PLAYERS][32];  
new const String:CP_FULL_SOUND_PATH[] = "sound/quake/wickedsick.mp3";
new const String:CP_RELATIVE_SOUND_PATH[] = "*quake/wickedsick.mp3";
new const String:PRO_FULL_SOUND_PATH[] = "sound/quake/holyshit.mp3";
new const String:PRO_RELATIVE_SOUND_PATH[] = "*quake/holyshit.mp3";
new const String:RELATIVE_BUTTON_PATH[] = "*buttons/button3.wav";
new const String:LEETJUMP_FULL_SOUND_PATH[] = "sound/quake/godlike.mp3";
new const String:LEETJUMP_RELATIVE_SOUND_PATH[] = "*quake/godlike.mp3";
new const String:LEETJUMP_RAMPAGE_FULL_SOUND_PATH[] = "sound/quake/rampage.mp3";
new const String:LEETJUMP_RAMPAGE_RELATIVE_SOUND_PATH[] = "*quake/rampage.mp3";
new const String:LEETJUMP_DOMINATING_FULL_SOUND_PATH[] = "sound/quake/dominating.mp3";
new const String:LEETJUMP_DOMINATING_RELATIVE_SOUND_PATH[] = "*quake/dominating.mp3";
new const String:PROJUMP_FULL_SOUND_PATH[] = "sound/quake/perfect.mp3";
new const String:PROJUMP_RELATIVE_SOUND_PATH[] = "*quake/perfect.mp3";
new String:RadioCMDS[][] = {"coverme", "takepoint", "holdpos", "regroup", "followme", "takingfire", "go", "fallback", "sticktog",
	"getinpos", "stormfront", "report", "roger", "enemyspot", "needbackup", "sectorclear", "inposition", "reportingin",
	"getout", "negative","enemydown","cheer","thanks","nice","compliment"};

new String:BlockedChatText[][] = {"!knife","!help","!bhop","!usp","!helpmenu","!menu","!menu ","!checkpoint","!gocheck","!unstuck",
	"!stuck","!r","!s","!prev","!next","!start","!stop","!pause","/knife","/help","/bhop","/helpmenu","/menu","/menu ","/checkpoint",
	"/gocheck","/unstuck","/stuck","/r","/s","/prev","/next","/usp","/start","/stop","/pause"};

// Botmimic2 Peace-Maker
// http://forums.alliedmods.net/showthread.php?t=164148
new Handle:g_hBotMimicsRecord[MAXPLAYERS+1] = {INVALID_HANDLE,...};
new Handle:g_hRecording[MAXPLAYERS+1];
new Handle:g_hRecordingAdditionalTeleport[MAXPLAYERS+1];
new Handle:g_hLoadedRecordsAdditionalTeleport;
new Float:g_fInitialPosition[MAXPLAYERS+1][3];
new Float:g_fInitialAngles[MAXPLAYERS+1][3];
new bool:g_bValidTeleportCall[MAXPLAYERS+1];
new g_iBotMimicRecordTickCount[MAXPLAYERS+1] = {0,...};
new g_iBotActiveWeapon[MAXPLAYERS+1] = {-1,...};
new g_iCurrentAdditionalTeleportIndex[MAXPLAYERS+1];
new g_iRecordedTicks[MAXPLAYERS+1];
new g_iRecordPreviousWeapon[MAXPLAYERS+1];
new g_iOriginSnapshotInterval[MAXPLAYERS+1];
new g_iBotMimicTick[MAXPLAYERS+1] = {0,...};
new String:g_sRecordName[MAXPLAYERS+1][MAX_RECORD_NAME_LENGTH];

#include "kztimer/admin.sp"
#include "kztimer/commands.sp"
#include "kztimer/hooks.sp"
#include "kztimer/buttonpress.sp"
#include "kztimer/sql.sp"
#include "kztimer/misc.sp"
#include "kztimer/timer.sp"
#include "kztimer/replay.sp"
#include "kztimer/globalconnection.sp"
	
public Plugin:
myinfo = {
	name = "kztimer",
	author = "1NutWunDeR",
	description = "",
	version = VERSION,
	url = "https://www.sourcemod.net/showthread.php?t=223274"
}

public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	hStartPress = CreateGlobalForward("CL_OnStartTimerPress", ET_Ignore, Param_Cell);
	hEndPress = CreateGlobalForward("CL_OnEndTimerPress", ET_Ignore, Param_Cell);
	return APLRes_Success;
}

public OnPluginStart()
{
	LoadTranslations("kztimer.phrases");	
	CreateConVar("kztimer_version", VERSION, "kztimer Version.", FCVAR_DONTRECORD|FCVAR_PLUGIN|FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY);

	//Tickrate
	new Float:fltickrate = 1.0 / GetTickInterval( );
	if (fltickrate > 65)
		g_btickrate64=false;
	else
		g_btickrate64=true;
			
	g_hReplayBot = CreateConVar("kz_replay_bot", "1", "on/off - Bots mimic the local tp and pro record (advice: rcon sv_cheats 1 and cl_draw_only_deathnotices 1 if you record a video)", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_bReplayBot     = GetConVarBool(g_hReplayBot);
	HookConVarChange(g_hReplayBot, OnSettingChanged);	
	
	g_hPreStrafe = CreateConVar("kz_prestrafe", "1", "on/off - Prestrafe + USP-Speed 250.0 (Experimental: Disable this function if your server crashes without errorlogs.)", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_bPreStrafe     = GetConVarBool(g_hPreStrafe);
	HookConVarChange(g_hPreStrafe, OnSettingChanged);	

	g_hForceJumpPenalty = CreateConVar("kz_force_jump_penalty", "0", "on/off - Force jump penalty for players (iceskating fix)", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_bForceJumpPenalty     = GetConVarBool(g_hForceJumpPenalty);
	HookConVarChange(g_hForceJumpPenalty, OnSettingChanged);	
	
	g_hNoClipS = CreateConVar("kz_noclip", "1", "on/off - Allow players to use noclip when they have finished the map", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_bNoClipS     = GetConVarBool(g_hNoClipS);
	HookConVarChange(g_hNoClipS, OnSettingChanged);	
	
	g_hfpsCheck = 	CreateConVar("kz_fps_check", "1", "on/off - Kick players if their fps_max is 0 or bigger than 300", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_bfpsCheck     = GetConVarBool(g_hfpsCheck);
	HookConVarChange(g_hfpsCheck, OnSettingChanged);	
	
	g_hGlobalDB = CreateConVar("kz_global_database", "1", "on/off - Global database", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_bGlobalDB     = GetConVarBool(g_hGlobalDB);
	HookConVarChange(g_hGlobalDB, OnSettingChanged);			
	
	g_hAutoTimer = CreateConVar("kz_auto_timer", "0", "on/off - Timer starts automatically when a player joins a team (global records disabled if activated)", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_bAutoTimer     = GetConVarBool(g_hAutoTimer);
	HookConVarChange(g_hAutoTimer, OnSettingChanged);

	g_hGoToServer = CreateConVar("kz_goto", "1", "on/off - Teleporting to an other player", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_bGoToServer     = GetConVarBool(g_hGoToServer);
	HookConVarChange(g_hGoToServer, OnSettingChanged);	
	
	g_hcvargodmode = CreateConVar("kz_godmode", "1", "on/off - Players are immortal", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_bgodmode     = GetConVarBool(g_hcvargodmode);
	HookConVarChange(g_hcvargodmode, OnSettingChanged);

	g_hPauseServerside    = CreateConVar("kz_pause", "1", "on/off - Allows players to use pauses during a climb", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_bPauseServerside    = GetConVarBool(g_hPauseServerside);
	HookConVarChange(g_hPauseServerside, OnSettingChanged);

	g_hcvarRestore    = CreateConVar("kz_restore", "1", "on/off - Restore of time and last position after reconnect (only if timer was activated)", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_bRestore        = GetConVarBool(g_hcvarRestore);
	HookConVarChange(g_hcvarRestore, OnSettingChanged);
	
	g_hcvarNoBlock    = CreateConVar("kz_noblock", "1", "on/off - Player blocking", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_bNoBlock        = GetConVarBool(g_hcvarNoBlock);
	HookConVarChange(g_hcvarNoBlock, OnSettingChanged);
	
	g_hAllowCheckpoints = CreateConVar("kz_checkpoints", "1", "on/off - Allows checkpoints", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_bAllowCheckpoints     = GetConVarBool(g_hAllowCheckpoints);
	HookConVarChange(g_hAllowCheckpoints, OnSettingChanged);	
	
	g_hEnforcer = CreateConVar("kz_settings_enforcer", "1", "on/off - KZ settings enforcer (forces global climb settings)", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_bEnforcer     = GetConVarBool(g_hEnforcer);
	HookConVarChange(g_hEnforcer, OnSettingChanged);
	
	g_hAutoRespawn = CreateConVar("kz_autorespawn", "1", "on/off - Players respawn if they die", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_bAutoRespawn     = GetConVarBool(g_hAutoRespawn);
	HookConVarChange(g_hAutoRespawn, OnSettingChanged);	

	g_hRadioCommands = CreateConVar("kz_use_radio", "0", "on/off - Allows players to use radio commands", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_bRadioCommands     = GetConVarBool(g_hRadioCommands);
	HookConVarChange(g_hRadioCommands, OnSettingChanged);	
	
	g_hAutohealing_Hp 	= CreateConVar("kz_autoheal", "50", "Set HP amount for autohealing (only active when kz_godmode 0)", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 100.0);
	g_Autohealing_Hp     = GetConVarInt(g_hAutohealing_Hp);
	HookConVarChange(g_hAutohealing_Hp, OnSettingChanged);	
	
	g_hCleanWeapons 	= CreateConVar("kz_clean_weapons", "1", "on/off - Removing of player weapons and weapons which lie on the ground", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_bCleanWeapons     = GetConVarBool(g_hCleanWeapons);
	HookConVarChange(g_hCleanWeapons, OnSettingChanged);

	g_hJumpStats 	= CreateConVar("kz_jumpstats", "1", "on/off - Measuring of jump distances", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_bJumpStats     = GetConVarBool(g_hJumpStats);
	HookConVarChange(g_hJumpStats, OnSettingChanged);	
	
	g_hCountry 	= CreateConVar("kz_country_tag", "1", "on/off - country chat tag (ip request could cause lags on bad server when a player joins)", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_bCountry     = GetConVarBool(g_hCountry);
	HookConVarChange(g_hCountry, OnSettingChanged);
	
	g_hAutoBhop 	= CreateConVar("kz_auto_bhop", "1", "on/off - AutoBhop on bhop_ & surf_ maps (climb maps are not supported, KZTimer disables Macrodox when activated)", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_bAutoBhop     = GetConVarBool(g_hAutoBhop);
	HookConVarChange(g_hAutoBhop, OnSettingChanged);

	g_hBhopSpeedCap   = CreateConVar("kz_prespeed_cap", "380.0", "Limits player's pre speed", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 300.0, true, 5000.0);
	g_fBhopSpeedCap    = GetConVarFloat(g_hBhopSpeedCap);
	HookConVarChange(g_hBhopSpeedCap, OnSettingChanged);	
	
	g_hPointSystem    = CreateConVar("kz_point_system", "1", "on/off - Player point system (map restart required)", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_bPointSystem    = GetConVarBool(g_hPointSystem);
	HookConVarChange(g_hPointSystem, OnSettingChanged);
	
	g_hPlayerpointsScale   	= CreateConVar("kz_point_system_scale", "1.0", "Scale the dynamic multiplier for points", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.1, true, 2.0);
	g_fPlayerpointsScale    = GetConVarFloat(g_hPlayerpointsScale);
	HookConVarChange(g_hPlayerpointsScale, OnSettingChanged);	

	g_hPlayerSkinChange 	= CreateConVar("kz_custom_models", "1", "on/off - Allows the plugin to change the player&bot models", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_bPlayerSkinChange     = GetConVarBool(g_hPlayerSkinChange);
	HookConVarChange(g_hPlayerSkinChange, OnSettingChanged);
	
	g_hReplayBotPlayerModel   = CreateConVar("kz_replay_bot_skin", "models/player/tm_professional_var1.mdl", "Replay bot skin", FCVAR_PLUGIN|FCVAR_NOTIFY);
	GetConVarString(g_hReplayBotPlayerModel,g_sReplayBotPlayerModel,256);
	HookConVarChange(g_hReplayBotPlayerModel, OnSettingChanged);	
	
	g_hReplayBotArmModel   = CreateConVar("kz_replay_bot_arm_skin", "models/weapons/t_arms_professional.mdl", "Replay bot arm skin", FCVAR_PLUGIN|FCVAR_NOTIFY);
	GetConVarString(g_hReplayBotArmModel,g_sReplayBotArmModel,256);
	HookConVarChange(g_hReplayBotArmModel, OnSettingChanged);	
	
	g_hPlayerModel   = CreateConVar("kz_player_skin", "models/player/ctm_sas_varianta.mdl", "Player skin", FCVAR_PLUGIN|FCVAR_NOTIFY);
	GetConVarString(g_hPlayerModel,g_sPlayerModel,256);
	HookConVarChange(g_hPlayerModel, OnSettingChanged);	
	
	g_hArmModel   = CreateConVar("kz_player_arm_skin", "models/weapons/ct_arms_sas.mdl", "Player arm skin", FCVAR_PLUGIN|FCVAR_NOTIFY);
	GetConVarString(g_hArmModel,g_sArmModel,256);
	HookConVarChange(g_hArmModel, OnSettingChanged);
	
	g_hWelcomeMsg   = CreateConVar("kz_welcome_msg", "Welcome. This server is using KZ Timer","Welcome message", FCVAR_PLUGIN);
	GetConVarString(g_hWelcomeMsg,g_sWelcomeMsg,512);
	HookConVarChange(g_hWelcomeMsg, OnSettingChanged);
	
	//jump physics depend on tickrate.. therefore different defaults
	if (g_btickrate64)
	{
		g_hMaxBhopPreSpeed   = CreateConVar("kz_max_prespeed_bhop_dropbhop", "325.0", "Max counted pre speed for bhop,dropbhop (no speed limiter)", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 300.0, true, 400.0);
		g_hdist_good_lj    	= CreateConVar("kz_dist_min_lj", "230.0", "Minimum distance for longjumps to be considered good [Client Message]", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 200.0, true, 999.0);
		if (!g_bPreStrafe)
		{
			g_hdist_pro_lj   	= CreateConVar("kz_dist_pro_lj", "243.0", "Minimum distance for longjumps to be considered pro [JumpStats Colorchat All]", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 220.0, true, 999.0);
			g_hdist_leet_lj    	= CreateConVar("kz_dist_leet_lj", "247.0", "Minimum distance for longjumps to be considered leet [JumpStats Colorchat All]", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 245.0, true, 999.0);	
		}
		else
		{
			g_hdist_pro_lj   	= CreateConVar("kz_dist_pro_lj", "253.0", "Minimum distance for longjumps to be considered pro [JumpStats Colorchat All]", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 220.0, true, 999.0);
			g_hdist_leet_lj    	= CreateConVar("kz_dist_leet_lj", "260.0", "Minimum distance for longjumps to be considered leet [JumpStats Colorchat All]", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 245.0, true, 999.0);		
		}
		g_hdist_good_weird  = CreateConVar("kz_dist_min_wj", "230.0", "Minimum distance for weird jumps to be considered good [Client Message]", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 200.0, true, 999.0);
		g_hdist_pro_weird  = CreateConVar("kz_dist_pro_wj", "265.0", "Minimum distance for weird jumps to be considered pro [JumpStats Colorchat All]", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 200.0, true, 999.0);
		g_hdist_leet_weird   = CreateConVar("kz_dist_leet_wj", "275.0", "Minimum distance for weird jumps to be considered leet [JumpStats Colorchat All]", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 200.0, true, 999.0);
		g_hdist_good_dropbhop  = CreateConVar("kz_dist_min_dropbhop", "240.0", "Minimum distance for drop bhops to be considered good [Client Message]", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 200.0, true, 999.0);
		g_hdist_pro_dropbhop  = CreateConVar("kz_dist_pro_dropbhop", "290.0", "Minimum distance for drop bhops to be considered pro [JumpStats Colorchat All]", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 200.0, true, 999.0);
		g_hdist_leet_dropbhop   = CreateConVar("kz_dist_leet_dropbhop", "297.0", "Minimum distance for drop bhops to be considered leet [JumpStats Colorchat All]", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 200.0, true, 999.0);
		g_hdist_good_bhop  = CreateConVar("kz_dist_min_bhop", "240.0", "Minimum distance for bhops to be considered good [Client Message]", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 200.0, true, 999.0);
		g_hdist_pro_bhop  = CreateConVar("kz_dist_pro_bhop", "290.0", "Minimum distance for bhops to be considered pro [JumpStats Colorchat All]", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 200.0, true, 999.0);
		g_hdist_leet_bhop   = CreateConVar("kz_dist_leet_bhop", "295.0", "Minimum distance for bhops to be considered leet [JumpStats Colorchat All]", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 200.0, true, 999.0);
		g_hdist_good_multibhop  = CreateConVar("kz_dist_min_multibhop", "260.0", "Minimum distance for multi-bhops to be considered good [Client Message]", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 200.0, true, 9999.0);
		g_hdist_pro_multibhop  = CreateConVar("kz_dist_pro_multibhop", "330.0", "Minimum distance for multi-bhops to be considered pro [JumpStats Colorchat All]", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 200.0, true, 9999.0);
		g_hdist_leet_multibhop   = CreateConVar("kz_dist_leet_multibhop", "340.0", "Minimum distance for multi-bhops to be considered leet [JumpStats Colorchat All]", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 200.0, true, 9999.0);
	}
	else
	{
		g_hMaxBhopPreSpeed   = CreateConVar("kz_max_prespeed_bhop_dropbhop", "360.0", "Max counted pre speed for bhop,dropbhop and wj (no speed limiter)", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 300.0, true, 400.0);
		g_hdist_good_lj    	= CreateConVar("kz_dist_min_lj", "235.0", "Minimum distance for longjumps to be considered good [Client Message]", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 200.0, true, 999.0);
		if (!g_bPreStrafe)
		{
			g_hdist_pro_lj   	= CreateConVar("kz_dist_pro_lj", "253.0", "Minimum distance for longjumps to be considered pro [JumpStats Colorchat All]", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 220.0, true, 999.0);
			g_hdist_leet_lj    	= CreateConVar("kz_dist_leet_lj", "260.0", "Minimum distance for longjumps to be considered leet [JumpStats Colorchat All]", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 245.0, true, 999.0);	
		}
		else
		{
			g_hdist_pro_lj   	= CreateConVar("kz_dist_pro_lj", "255.0", "Minimum distance for longjumps to be considered pro [JumpStats Colorchat All]", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 220.0, true, 999.0);
			g_hdist_leet_lj    	= CreateConVar("kz_dist_leet_lj", "265.0", "Minimum distance for longjumps to be considered leet [JumpStats Colorchat All]", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 245.0, true, 999.0);		
		}
		g_hdist_good_weird  = CreateConVar("kz_dist_min_wj", "230.0", "Minimum distance for weird jumps to be considered good [Client Message]", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 200.0, true, 999.0);
		g_hdist_pro_weird  = CreateConVar("kz_dist_pro_wj", "270.0", "Minimum distance for weird jumps to be considered pro [JumpStats Colorchat All]", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 200.0, true, 999.0);
		g_hdist_leet_weird   = CreateConVar("kz_dist_leet_wj", "276.0", "Minimum distance for weird jumps to be considered leet [JumpStats Colorchat All]", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 200.0, true, 999.0);
		g_hdist_good_dropbhop  = CreateConVar("kz_dist_min_dropbhop", "275.0", "Minimum distance for drop bhops to be considered good [Client Message]", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 200.0, true, 999.0);
		g_hdist_pro_dropbhop  = CreateConVar("kz_dist_pro_dropbhop", "320.0", "Minimum distance for drop bhops to be considered pro [JumpStats Colorchat All]", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 200.0, true, 999.0);
		g_hdist_leet_dropbhop   = CreateConVar("kz_dist_leet_dropbhop", "330.0", "Minimum distance for drop bhops to be considered leet [JumpStats Colorchat All]", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 200.0, true, 999.0);
		g_hdist_good_bhop  = CreateConVar("kz_dist_min_bhop", "280.0", "Minimum distance for bhops to be considered good [Client Message]", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 200.0, true, 999.0);
		g_hdist_pro_bhop  = CreateConVar("kz_dist_pro_bhop", "315.0", "Minimum distance for bhops to be considered pro [JumpStats Colorchat All]", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 200.0, true, 999.0);
		g_hdist_leet_bhop   = CreateConVar("kz_dist_leet_bhop", "327.0", "Minimum distance for bhops to be considered leet [JumpStats Colorchat All]", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 200.0, true, 999.0);
		g_hdist_good_multibhop  = CreateConVar("kz_dist_min_multibhop", "260.0", "Minimum distance for multi-bhops to be considered good [Client Message]", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 200.0, true, 9999.0);
		g_hdist_pro_multibhop  = CreateConVar("kz_dist_pro_multibhop", "330.0", "Minimum distance for multi-bhops to be considered pro [JumpStats Colorchat All]", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 200.0, true, 9999.0);
		g_hdist_leet_multibhop   = CreateConVar("kz_dist_leet_multibhop", "340.0", "Minimum distance for multi-bhops to be considered leet [JumpStats Colorchat All]", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 200.0, true, 9999.0);		
	}	
		
	g_fMaxBhopPreSpeed    = GetConVarFloat(g_hMaxBhopPreSpeed);
	HookConVarChange(g_hMaxBhopPreSpeed, OnSettingChanged);	
		
	g_dist_good_weird	= GetConVarFloat(g_hdist_good_weird);
	HookConVarChange(g_hdist_good_weird, OnSettingChanged);	

	g_dist_pro_weird	= GetConVarFloat(g_hdist_pro_weird);
	HookConVarChange(g_hdist_pro_weird, OnSettingChanged);	
	
	g_dist_leet_weird    = GetConVarFloat(g_hdist_leet_weird);
	HookConVarChange(g_hdist_leet_weird, OnSettingChanged);	

	g_dist_good_dropbhop	= GetConVarFloat(g_hdist_good_dropbhop);
	HookConVarChange(g_hdist_good_dropbhop, OnSettingChanged);	
	
	g_dist_pro_dropbhop	= GetConVarFloat(g_hdist_pro_dropbhop);
	HookConVarChange(g_hdist_pro_dropbhop, OnSettingChanged);	
	
	g_dist_leet_dropbhop    = GetConVarFloat(g_hdist_leet_dropbhop);
	HookConVarChange(g_hdist_leet_dropbhop, OnSettingChanged);	
		
	g_dist_good_bhop	= GetConVarFloat(g_hdist_good_bhop);
	HookConVarChange(g_hdist_good_bhop, OnSettingChanged);	
	
	g_dist_pro_bhop	= GetConVarFloat(g_hdist_pro_bhop);
	HookConVarChange(g_hdist_pro_bhop, OnSettingChanged);	
	
	g_dist_leet_bhop    = GetConVarFloat(g_hdist_leet_bhop);
	HookConVarChange(g_hdist_leet_bhop, OnSettingChanged);	
	
	g_dist_good_multibhop	= GetConVarFloat(g_hdist_good_multibhop);
	HookConVarChange(g_hdist_good_multibhop, OnSettingChanged);	
	
	g_dist_pro_multibhop	= GetConVarFloat(g_hdist_pro_multibhop);
	HookConVarChange(g_hdist_pro_multibhop, OnSettingChanged);	

	g_dist_leet_multibhop    = GetConVarFloat(g_hdist_leet_multibhop);
	HookConVarChange(g_hdist_leet_multibhop, OnSettingChanged);	
		
	g_dist_good_lj      = GetConVarFloat(g_hdist_good_lj);
	HookConVarChange(g_hdist_good_lj, OnSettingChanged);	
	
	g_dist_pro_lj      = GetConVarFloat(g_hdist_pro_lj);
	HookConVarChange(g_hdist_pro_lj, OnSettingChanged);	
	
	g_dist_leet_lj      = GetConVarFloat(g_hdist_leet_lj);
	HookConVarChange(g_hdist_leet_lj, OnSettingChanged);	
	
	db_setupDatabase();
	deleteDeadDBTmps();
	
	//client commands
	RegConsoleCmd("sm_accept", Client_Accept);
	RegConsoleCmd("sm_jumppenalty", Client_jumppenalty);
	RegConsoleCmd("sm_goto", Client_GoTo);
	RegConsoleCmd("sm_disablegoto", Client_DisableGoTo);
	RegConsoleCmd("sm_showkeys", Client_InfoPanel);
	RegConsoleCmd("sm_info", Client_InfoPanel);
	RegConsoleCmd("sm_playernames", Client_Shownames);
	RegConsoleCmd("sm_menusound", Client_ClimbersMenuSounds);
	RegConsoleCmd("sm_sync", Client_StrafeSync);
	RegConsoleCmd("sm_sound", Client_QuakeSounds);
	RegConsoleCmd("sm_cpmessage", Client_CPMessage);
	RegConsoleCmd("sm_surrender", Client_Surrender);
	RegConsoleCmd("sm_next", Client_Next);
	RegConsoleCmd("sm_usp", Client_Usp);
	RegConsoleCmd("sm_bhop", Client_AutoBhop);
	RegConsoleCmd("sm_undo", Client_Undo);
	RegConsoleCmd("sm_prev", Client_Prev);
	RegConsoleCmd("sm_adv", Client_AdvClimbersMenu);
	RegConsoleCmd("sm_unstuck", Client_Prev);
	RegConsoleCmd("sm_stuck", Client_Prev);
	RegConsoleCmd("sm_checkpoint", Client_Save);
	RegConsoleCmd("sm_gocheck", Client_Tele);
	RegConsoleCmd("sm_hidespecs", Client_HideSpecs);
	RegConsoleCmd("sm_compare", Client_Compare);
	RegConsoleCmd("sm_menu", Client_Kzmenu);
	RegConsoleCmd("sm_abort", Client_Abort);
	RegConsoleCmd("sm_spec", Client_Spec);
	RegConsoleCmd("sm_watch", Client_Spec);
	RegConsoleCmd("sm_spectate", Client_Spec);
	RegConsoleCmd("sm_challenge", Client_Challenge);
	RegConsoleCmd("sm_helpmenu", Client_Help);
	RegConsoleCmd("sm_help", Client_Help);
	RegConsoleCmd("sm_profile", Client_Profile);
	RegConsoleCmd("sm_rank", Client_Profile);
	RegConsoleCmd("sm_options", Client_OptionMenu);
	RegConsoleCmd("sm_top", Client_Top);
	RegConsoleCmd("sm_topclimbers", Client_Top);
	RegConsoleCmd("sm_top15", Client_Top);
	RegConsoleCmd("sm_start", Client_Start);
	RegConsoleCmd("sm_r", Client_Start);
	RegConsoleCmd("sm_s", Client_Start);
	RegConsoleCmd("sm_stop", Client_Stop);
	RegConsoleCmd("sm_speed", Client_InfoPanel);
	RegConsoleCmd("sm_pause", Client_Pause);
	RegConsoleCmd("sm_colorchat", Client_Colorchat);
	RegConsoleCmd("sm_showsettings", Client_Showsettings);
	RegConsoleCmd("sm_showtime", Client_Showtime);	
	RegConsoleCmd("sm_shownames", Client_Shownames);
	RegConsoleCmd("sm_hide", Client_Hide); 
	RegConsoleCmd("+noclip", NoClip);
	RegConsoleCmd("-noclip", UnNoClip);
	RegAdminCmd("sm_kzadmin", Admin_KzPanel, ADMIN_LEVEL, "Displays the kz admin panel");
	RegAdminCmd("sm_resettimes", Admin_DropAllMapRecords, ADMIN_LEVEL, "Reset player times (drops table playertimes)");
	RegAdminCmd("sm_resetranks", Admin_DropPlayerRanks, ADMIN_LEVEL, "Resets the player point system (drops table playerrank)");
	RegAdminCmd("sm_resetmaptimes", Admin_ResetMapRecords, ADMIN_LEVEL, "Reset player times for given map");
	RegAdminCmd("sm_resetplayertimes", Admin_ResetRecords, ADMIN_LEVEL, "Reset tp & pro map times for given steamid with or without given map");
	RegAdminCmd("sm_resetjumpstats", Admin_DropPlayerJump, ADMIN_LEVEL, "Reset jump stats (drops table playerjumpstats)");
	RegAdminCmd("sm_resetljrecord", Admin_ResetLjRecords, ADMIN_LEVEL, "Resets lj record for given steamid");
	RegAdminCmd("sm_resetbhoprecord", Admin_ResetBhopRecords, ADMIN_LEVEL, "Resets bhop record for given steamid");	
	RegAdminCmd("sm_resetdropbhoprecord", Admin_ResetDropBhopRecords, ADMIN_LEVEL, "Resets drop bhop record for given steamid");
	RegAdminCmd("sm_resetwjrecord", Admin_ResetWjRecords, ADMIN_LEVEL, "Resets wj record for given steamid");	
	RegAdminCmd("sm_resetmultibhoprecord", Admin_ResetMultiBhopRecords, ADMIN_LEVEL, "Resets multi bhop record for given steamid");
	RegAdminCmd("sm_deleteproreplay", Admin_DeleteProReplay, ADMIN_LEVEL, "Deletes pro replay for a given map");
	RegAdminCmd("sm_deletetpreplay", Admin_DeleteTpReplay, ADMIN_LEVEL, "Deletes tp replay for a given map");	
	RegAdminCmd("sm_getmultiplier", Admin_GetMulitplier, ADMIN_LEVEL, "Get dynamic multiplier for given player");
	RegAdminCmd("sm_setmultiplier", Admin_SetMulitplier, ADMIN_LEVEL, "Set dynamic multiplier for given player and mutliplier value");	
	RegConsoleCmd("say", Say_Hook);
	RegConsoleCmd("say_team", Say_Hook);
	AutoExecConfig(true, "kztimer");
	ownerOffset = FindSendPropOffs("CBaseCombatWeapon", "m_hOwnerEntity");
	
	//add to admin menu
	new Handle:topmenu;
	if (LibraryExists("adminmenu") && ((topmenu = GetAdminTopMenu()) != INVALID_HANDLE))
		OnAdminMenuReady(topmenu);
		
	//hooks
	HookEvent("player_spawn", Event_OnPlayerSpawn);
	HookEvent("player_death", Event_OnPlayerDeath);
	HookEvent("round_start", Event_OnRoundStart);
	HookEvent("player_hurt", Event_OnPlayerHurt);
	HookEvent("player_jump", Event_OnJump);
	HookEvent("player_team", EventTeamChange, EventHookMode_Post);
	HookEntityOutput("func_button", "OnPressed", ButtonPress);
	
	//mapcycle array
	new arraySize = ByteCountToCells(PLATFORM_MAX_PATH);
	g_MapList = CreateArray(arraySize);	
	
	//command listener
	AddCommandListener(Command_ext_Menu, "sm_nominate");
	AddCommandListener(Command_ext_Menu, "sm_admin");
	AddCommandListener(Command_ext_Menu, "sm_call");
	AddCommandListener(Command_ext_Menu, "sm_votekick");
	AddCommandListener(Command_ext_Menu, "sm_voteban");
	AddCommandListener(Command_ext_Menu, "sm_votemenu");
	AddCommandListener(Command_ext_Menu, "sm_radio");
	AddCommandListener(Command_ext_Menu, "radio1");
	AddCommandListener(Command_ext_Menu, "radio2");
	AddCommandListener(Command_ext_Menu, "radio3");
	AddCommandListener(Command_ext_Menu, "sm_jb"); 
	AddCommandListener(Command_ext_Menu, "sm_knife"); 
	AddCommandListener(Command_JoinTeam, "jointeam");
	for(new i; i < sizeof(RadioCMDS); i++)
		AddCommandListener(BlockRadio, RadioCMDS[i]);
	
	//botmimic 2
	CheatFlag("bot_zombie", false, true);
	g_hLoadedRecordsAdditionalTeleport = CreateTrie();
	if(LibraryExists("dhooks"))
		OnLibraryAdded("dhooks");
	
}
public OnLibraryAdded(const String:name[])
{
	if(StrEqual(name, "dhooks") && g_hTeleport == INVALID_HANDLE)
	{
		// Optionally setup a hook on CBaseEntity::Teleport to keep track of sudden place changes
		new Handle:hGameData = LoadGameConfigFile("sdktools.games");
		if(hGameData == INVALID_HANDLE)
			return;
		new iOffset = GameConfGetOffset(hGameData, "Teleport");
		CloseHandle(hGameData);
		if(iOffset == -1)
			return;

		g_hTeleport = DHookCreate(iOffset, HookType_Entity, ReturnType_Void, ThisPointer_CBaseEntity, DHooks_OnTeleport);
		if(g_hTeleport == INVALID_HANDLE)
			return;
		DHookAddParam(g_hTeleport, HookParamType_VectorPtr);
		DHookAddParam(g_hTeleport, HookParamType_ObjectPtr);
		DHookAddParam(g_hTeleport, HookParamType_VectorPtr);
		if(GetEngineVersion() == Engine_CSGO)
			DHookAddParam(g_hTeleport, HookParamType_Bool);

		for(new i=1;i<=MaxClients;i++)
		{
			if(IsClientInGame(i))
				OnClientPutInServer(i);
		}
	}
}

public OnLibraryRemoved(const String:name[])
{
	if (StrEqual(name, "adminmenu"))
		g_hAdminMenu = INVALID_HANDLE;
	if(StrEqual(name, "dhooks"))
		g_hTeleport = INVALID_HANDLE;
}

public OnMapStart()
{
	g_fMapStartTime = GetEngineTime();
	g_bMapButtons=false;
	g_fRecordTime=9999999.0;
	g_fRecordTimePro=9999999.0;
	g_fRecordTimeGlobal=9999999.0;
	g_fRecordTimeGlobal128=9999999.0;
	g_maptimes_pro = 0;
	g_maptimes_tp = 0;
	g_iBot = -1;
	g_iBot2 = -1;
	g_bBhopPluginEnabled = false;
	g_bBhopHackProtection = false;
	g_bAutoBhop2=false;
	
	//get mapname
	decl String:mapPath[256];
	new bool: fileFound;
	GetCurrentMap(g_szMapName, MAX_MAP_LENGTH);
	Format(mapPath, sizeof(mapPath), "maps/%s.bsp", g_szMapName); 	
	fileFound = FileExists(mapPath);
	
	//fix workshop mapname
	new String:mapPieces[6][128];
	new lastPiece = ExplodeString(g_szMapName, "/", mapPieces, sizeof(mapPieces), sizeof(mapPieces[])); 
	Format(g_szMapName, sizeof(g_szMapName), "%s", mapPieces[lastPiece-1]); 
   
	//get map tag
	ExplodeString(g_szMapName, "_", g_szMapTag, 2, 32);
	g_bglobalValidFilesize=false;

	//get local map records
	db_GetMapRecord_CP();
	db_GetMapRecord_Pro();
	
	//players count
	db_CalculatePlayerCount();
	db_CalculatePlayerCountBigger0();
	
	//map ranks count
	db_viewMapProRankCount();
	db_viewMapTpRankCount();

	InitPrecache();	
	SetCashState();
	CreateTimer(0.1, MainTimer, _, TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
	CreateTimer(1.0, MainTimer2, _, TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
	CreateTimer(2.0, RespawnTimer, _, TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
	CreateTimer(2.0, SettingsEnforcerTimer, _, TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
	CreateTimer(5.0, SecretTimer, _, TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
	CreateTimer(30.0, TriggerFPSCheck, _, TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
	CreateTimer(2.0, SpawnButtons, INVALID_HANDLE, TIMER_FLAG_NO_MAPCHANGE);	
	new String:tmp[64];
	
	CheatFlag("bot_zombie", false, true);	
	
	//srv settings
	ServerCommand("mp_spectators_max 60");
	ServerCommand("mp_limitteams 0");
	ServerCommand("sm_cvar mp_flashlight 1");		
	ServerCommand("sv_deadtalk 1");
	ServerCommand("sv_full_alltalk 1");
	ServerCommand("sv_alltalk 1");
	ServerCommand("mp_free_armor 1");
	ServerCommand("mp_do_warmup_period 0");		
	ServerCommand("mp_ignore_round_win_conditions 1");	
	ServerCommand("mp_autoteambalance 0");
	ServerCommand("mp_playerid 0");
	ServerCommand("bot_quota 0");
	if (g_bEnforcer)
		ServerCommand("sm_cvar sv_enablebunnyhopping 1");		
	Format(tmp,64, "bot_quota_mode %cnormal%c",QUOTE,QUOTE);
	ServerCommand(tmp);
	ServerCommand("bot_chatter off");
	ServerCommand("bot_join_after_player 0");
	ServerCommand("bot_zombie 1");
	if (g_bCleanWeapons)
		ServerCommand("sv_infinite_ammo 0");
	
	//valid timestamp? [global db]
	if (fileFound && g_BGlobalDBConnected && g_bGlobalDB)
	{	
		g_unique_FileSize =  FileSize(mapPath);
		//supported map tags 
		if(StrEqual(g_szMapTag[0],"kz") || StrEqual(g_szMapTag[0],"xc"))
			dbCheckFileSize();
	}	

	//BotMimic2
	LoadReplays();

	//AutoBhop?
	if(StrEqual(g_szMapTag[0],"surf") || StrEqual(g_szMapTag[0],"bhop") || StrEqual(g_szMapTag[0],"mg"))
		g_bAutoBhop2=true;
		
	if (g_bAutoBhop2)
		ServerCommand("sm plugins unload macrodox.smx");
	else
		ServerCommand("sm plugins load macrodox.smx");	
		
}

public OnConfigsExecuted()
{
	new String:map[128];
	new mapListSerial = -1;
	g_pr_mapcount=0;
	if (ReadMapList(g_MapList, 
			mapListSerial, 
			"mapcyclefile", 
			MAPLIST_FLAG_CLEARARRAY|MAPLIST_FLAG_NO_DEFAULT)
		== INVALID_HANDLE)
	{
		if (mapListSerial == -1)
		{
			SetFailState("Mapcycle Not Found");
		}
	}
	for (new i = 0; i < GetArraySize(g_MapList); i++)
	{
		GetArrayString(g_MapList, i, map, sizeof(map));
		if (!StrEqual(map, "", false))
		{
			//fix workshop map name	
			new String:mapPieces[6][64];
			new lastPiece = ExplodeString(map, "/", mapPieces, sizeof(mapPieces), sizeof(mapPieces[])); 
			Format(map, sizeof(map), "%s", map[lastPiece-1]); 
			SetArrayString(g_MapList, i, map);
			g_pr_mapcount++;
		}
	}	
		
	//Map Points	
	g_pr_dyn_maxpoints = RoundToCeil((g_pr_mapcount*g_fPlayerpointsScale)*300+(((g_pr_mapcount*g_fPlayerpointsScale)*300)*0.3));
	g_pr_rank_Novice = RoundToCeil(g_pr_dyn_maxpoints * 0.001);  
	g_pr_rank_Scrub = RoundToCeil(g_pr_dyn_maxpoints * 0.03); 
	g_pr_rank_Rookie = RoundToCeil(g_pr_dyn_maxpoints * 0.12);  
	g_pr_rank_Skilled = RoundToCeil(g_pr_dyn_maxpoints * 0.45);  
	g_pr_rank_Expert = RoundToCeil(g_pr_dyn_maxpoints * 0.75);  
	g_pr_rank_Pro = RoundToCeil(g_pr_dyn_maxpoints * 1.1);  
	g_pr_rank_Elite = RoundToCeil(g_pr_dyn_maxpoints * 1.5); 
	g_pr_rank_Master = RoundToCeil(g_pr_dyn_maxpoints * 2.0); 
	g_pr_points_finished = g_pr_rank_Novice;

	//map config
	decl String:szPath[256];
	Format(szPath, sizeof(szPath), "sourcemod/kztimer/%s_.cfg",g_szMapTag[0]);
	ServerCommand("exec %s", szPath);
}

public OnMapEnd()
{
	if (g_BGlobalDBConnected)
		db_deleteInvalidGlobalEntries();
}

public OnClientPutInServer(client)
{
	SDKHook(client, SDKHook_SetTransmit, Hook_SetTransmit);
	SDKHook(client, SDKHook_OnTakeDamage, OnTakeDamage);	
	
	if(LibraryExists("dhooks"))
	{
		if(g_hTeleport != INVALID_HANDLE)
			DHookEntity(g_hTeleport, false, client);
	}		
	if (g_bCountry)
		GetCountry(client);
}

public OnClientPostAdminCheck(client)
{				
	for( new i = 0; i < MAX_STRAFES; i++ )
	{
		g_strafe_good_sync[client][i] = 0.0;
		g_strafe_frames[client][i] = 0.0;
	}
	g_UspDrops[client] = 0;
	g_fPlayerCordsUndoTp[client][0] =0.0;
	g_fPlayerCordsUndoTp[client][1] =0.0;
	g_fPlayerCordsUndoTp[client][2] =0.0;
	g_bchallengeConnected[client] = true;
	g_challenge_win_ratio[client] = 0;
	g_challenge_points_ratio[client] = 0;
	g_bSpectate[client] = false;
	g_ground_frames[client] = 0;
	g_fPlayerConnectedTime[client]=GetEngineTime();			
	g_bFirstSpawn[client] = true;		
	g_CurrentCp[client] = -1;
	g_SpecTarget[client] = -1;
	g_CounterCp[client] = 0;
	g_OverallCp[client] = 0;
	g_OverallTp[client] = 0;
	g_pr_points[client] = 0;
	if (IsFakeClient(client))
		CS_SetMVPCount(client,1);	
	else
		g_MVPStars[client] = 0;
	g_LeetJumpDominating[client] = 0;
	g_bRestartCords[client] = false;
	g_bPlayerJumped[client] = false;
	g_brc_PlayerRank[client] = false;
	g_PrestrafeFrameCounter[client] = 0;
	g_PrestrafeVelocity[client] = 1.0;
	g_fRunTime[client] = 0.0;
	g_fStartTime[client] = -1.0;
	g_ground_frames[client] = 0;
	g_bPause[client] = false;
	g_bTopMenuOpen[client] = false;
	g_bCheckSurf[client] = false;
	g_bRestoreC[client] = false;
	g_bRestoreCMsg[client] = false;
	g_bRespawnPosition[client] = false;
	g_bNoClip[client] = false;		
	g_bMapFinished[client] = false;
	g_last_ground_frames[client] = 11;
	g_multi_bhop_count[client] = 1;
	Format(g_szPlayerPanelText[client], 512, "");
	Format(g_pr_rankname[client], 32, "");
	g_AdminMenuLastPage[client] = 0;
	g_OptionMenuLastPage[client] = 0;	
	g_bChallenge[client] = false;
	g_bOverlay[client]=false;
	g_bChallengeRequest[client] = false;
	g_bMapRankToChat[client] = false;
	g_fJump_InitialLastHeight[client] = -1.012345;
	g_fLastTimeDucked[client] = -1.0;
	g_fLastJumpDistance[client] = 0.0;		
	g_good_sync[client] = 0.0;
	g_fLastTimeNoClipUsed[client] = -1.0;
	g_sync_frames[client] = 0.0;
	g_maprank_tp[client] = 99999;
	g_maprank_pro[client] = 99999;
	g_fLastTime_DBQuery[client] = GetEngineTime();
	if (!IsClientInGame(client) || IsFakeClient(client))
		return;	
	
	//options
	g_bInfoPanel[client]=false;
	g_bClimbersMenuSounds[client]=true;
	g_bEnableQuakeSounds[client]=true;
	g_bShowNames[client]=true; 
	g_bStrafeSync[client]=false;
	g_bGoToClient[client]=true; 
	g_bShowTime[client]=true; 
	g_bHide[client]=false; 
	g_bCPTextMessage[client]=false; 
	g_bAdvancedClimbersMenu[client]=false;
	g_bColorChat[client]=true; 
	g_bShowSpecs[client]=true;
	g_bAutoBhopClient[client]=true;
	g_bJumpPenalty[client]=false;
	decl String:szSteamId[32];
	GetClientAuthString(client, szSteamId, 32);	
 	db_viewPersonalRecords(client,szSteamId,g_szMapName);	
	db_viewPersonalBhopRecord(client, szSteamId);
	db_viewPersonalMultiBhopRecord(client, szSteamId);	
	db_viewPersonalWeirdRecord(client, szSteamId);
	db_viewPersonalDropBhopRecord(client, szSteamId); 
	db_viewPersonalLJRecord(client, szSteamId);
	db_viewPlayerOptions(client, szSteamId);	
	
	//Restore time&position
	if(g_bRestore)
	{
		db_selectLastRun(client);	
		PlayerPanel(client);
	}
	else
		g_bTimeractivated[client] = false;	
			
	//console ouput
	decl String:NextMap[64];
	GetNextMap(NextMap, sizeof(NextMap));
	new timeleft;
	GetMapTimeLeft(timeleft)
	new mins, secs;	
	decl String:finalOutput[1024];
	mins = timeleft / 60;
	secs = timeleft % 60;
	Format(finalOutput, 1024, "%d:%02d", mins, secs);
	new mapbonus= RoundToNearest(g_pr_rank_Master/4.0);
	new Float:fltickrate = 1.0 / GetTickInterval( );
	PrintToConsole(client," ");
	PrintToConsole(client, "=======================================================================================================");
	PrintToConsole(client, "This server is running KZ Timer v%s - Tickrate: %i", VERSION, RoundToNearest(fltickrate));
	PrintToConsole(client, " ");
	if (timeleft > 0)
		PrintToConsole(client, "Timeleft: %s",finalOutput);
	PrintToConsole(client, "Nextmap: %s", NextMap);
	PrintToConsole(client, " ");
	PrintToConsole(client, "Info");
	PrintToConsole(client, "You should set cl_downloadfilter to %call%c to get the required plugin files!", QUOTE,QUOTE);
	PrintToConsole(client, " ");
	PrintToConsole(client, "Player commands");
	PrintToConsole(client, "!help, !menu, !options, !checkpoint, !gocheck, !prev, !next, !undo, !profile, !compare");
	PrintToConsole(client, "!top, !start, !stop, , !pause, !usp, !challenge, !surrender, !goto, !spec, !showsettings");
	PrintToConsole(client, "(options menu contains: !adv, !info, !colorchat, !cpmessage, !sound, !menusound");
	PrintToConsole(client, "!hide, !hidespecs, !showtime, !disablegoto, !shownames, !sync, !bhop, !ice)");
	PrintToConsole(client, " ");
	PrintToConsole(client, "Live scoreboard");
	PrintToConsole(client, "Kills: Time in seconds");
	PrintToConsole(client, "Assists: Checkpoints");
	PrintToConsole(client, "Deaths: Teleports");
	PrintToConsole(client, "MVP Stars: Number of finished map runs on the current map");
	PrintToConsole(client, " ");
	PrintToConsole(client, "Player point system");
	PrintToConsole(client, "You get points for finishing a map, top 100 times (depends on rank), map completion percentage,");
	PrintToConsole(client, "and JumpStats (top 20) + a %ip bonus if your map completion (tp+pro) has reached 100%", mapbonus);
	PrintToConsole(client, " ");
	PrintToConsole(client, "Skill groups:");
	PrintToConsole(client, "NOVICE (%ip)",g_pr_rank_Novice);
	PrintToConsole(client, "SCRUB (%ip)",g_pr_rank_Scrub);
	PrintToConsole(client, "ROOKIE (%ip)",g_pr_rank_Rookie);
	PrintToConsole(client, "SKILLED (%ip)",g_pr_rank_Skilled);
	PrintToConsole(client, "EXPERT (%ip)",g_pr_rank_Expert);
	PrintToConsole(client, "PRO (%ip)",g_pr_rank_Pro);
	PrintToConsole(client, "ELITE (%ip)",g_pr_rank_Elite);
	if (g_bNoClipS)
		PrintToConsole(client, "MASTER (%ip) - NoClip unlocked",g_pr_rank_Master);	
	else
		PrintToConsole(client, "MASTER (%ip)",g_pr_rank_Master);	
	PrintToConsole(client, "========================================================================================================");
	PrintToConsole(client, " ");		
}

public OnClientDisconnect(client)
{
	if (!IsValidEntity(client))
		return
	
	//stop bot mimic
	if(g_hBotMimicsRecord[client] != INVALID_HANDLE && IsFakeClient(client))
		StopPlayerMimic(client);
	
	if (IsFakeClient(client) || !IsClientInGame(client))
		return;
		
	decl String:szQuery[1024];   	
	decl String:szSteamId[32];
	GetClientAuthString(client, szSteamId, 32);
	
	//get last position
	if(GetEntDataEnt2(client, FindSendPropOffs("CBasePlayer", "m_hGroundEntity")) != -1)
	{
		GetClientAbsOrigin(client,g_fPlayerCordsRestore[client]);
		GetClientEyeAngles(client,g_fPlayerAnglesRestore[client]);  
	}
	else
	{
		g_fPlayerCordsRestore[client][0] = -1.0;
		g_fPlayerCordsRestore[client][1] = -1.0;
		g_fPlayerCordsRestore[client][2] = -1.0;
		g_fPlayerAnglesRestore[client][0] = -1.0;
		g_fPlayerAnglesRestore[client][1] = -1.0;
		g_fPlayerAnglesRestore[client][2] = -1.0;
	}
	
	//stop recording (replay system)
	if(g_hRecording[client] != INVALID_HANDLE)
		StopRecording(client);
	
	//DB: save last position & time if timer activated
	if(g_bTimeractivated[client] && g_bRestore && !g_bSpectate[client] && !IsFakeClient(client))
	{
		Format(szQuery, 1024, sql_updateRunTmp, g_fPlayerCordsRestore[client][0],g_fPlayerCordsRestore[client][1],g_fPlayerCordsRestore[client][2], g_fPlayerAnglesRestore[client][0],g_fPlayerAnglesRestore[client][1],g_fPlayerAnglesRestore[client][2], g_OverallTp[client], g_OverallCp[client], g_fRunTime[client],szSteamId, g_szMapName);
		SQL_TQuery(g_hDb,sql_updateRunTmpCallback,szQuery,DBPrio_Low);
	}    
	else
		if (g_bSpectate[client] && g_bTimeractivated[client]) 
			db_deleteTmp(client, szSteamId, g_szMapName); //delete tmp record (just to keep the db clear)

	//DB: Save player options if changed
	if (g_borg_JumpPenalty[client] != g_bJumpPenalty[client] || g_borg_AutoBhopClient[client] != g_bAutoBhopClient[client] || g_borg_ColorChat[client] != g_bColorChat[client] || g_borg_InfoPanel[client] != g_bInfoPanel[client] || g_borg_ClimbersMenuSounds[client] != g_bClimbersMenuSounds[client] ||  g_borg_EnableQuakeSounds[client] != g_bEnableQuakeSounds[client] || g_borg_ShowNames[client] != g_bShowNames[client] || g_borg_StrafeSync[client] != g_bStrafeSync[client] || g_borg_GoToClient[client] != g_bGoToClient[client] || g_borg_ShowTime[client] != g_bShowTime[client] || g_borg_Hide[client] != g_bHide[client] || g_borg_ShowSpecs[client] != g_bShowSpecs[client] || g_borg_CPTextMessage[client] != g_bCPTextMessage[client] || g_borg_AdvancedClimbersMenu[client] != g_bAdvancedClimbersMenu[client])
		db_updatePlayerOptions(client, szSteamId);
		
	//DB: Delete invalid playertimes for this map (just to keep the db clear)
	Format(szQuery, 1024, sql_deletePlayer, szSteamId, g_szMapName);
	SQL_TQuery(g_hDb,sql_deletePlayerCheckCallback,szQuery,DBPrio_Low);
}

public OnSettingChanged(Handle:convar, const String:oldValue[], const String:newValue[])
{	
	if(convar == g_hGoToServer)
	{
		if(newValue[0] == '1')
			g_bGoToServer = true;
		else
			g_bGoToServer = false;
	}
	if(convar == g_hfpsCheck)
	{
		if(newValue[0] == '1')
			g_bfpsCheck = true;	
		else
			g_bfpsCheck = false;
	}	
	if(convar == g_hPreStrafe)
	{
		if(newValue[0] == '1')
			g_bPreStrafe = true;
		else
			g_bPreStrafe = false;
	}	
	if(convar == g_hNoClipS)
	{
		if(newValue[0] == '1')
			g_bNoClipS = true;
		else
			g_bNoClipS = false;
	}		
	if(convar == g_hReplayBot)
	{
		if(newValue[0] == '1')
		{
			g_bReplayBot = true;
			LoadReplays();
		}
		else
		{
			g_bReplayBot = false;
			CreateTimer(0.0,KickBotsTimer,_,TIMER_FLAG_NO_MAPCHANGE);
		}
	}	
	if(convar == g_hGlobalDB)
	{
		if(newValue[0] == '1')
			g_bGlobalDB = true;
		else
			g_bGlobalDB = false;
	}	
	if(convar == g_hAutoTimer)
	{
		if(newValue[0] == '1')
			g_bAutoTimer = true;
		else
			g_bAutoTimer = false;
	}		
	if(convar == g_hPauseServerside)
	{
		if(newValue[0] == '1')
			g_bPauseServerside = true;
		else
			g_bPauseServerside = false;
	}
	if(convar == g_hAutohealing_Hp)
		g_Autohealing_Hp = StringToInt(newValue[0]);	
	
	if(convar == g_hAutoRespawn)
	{
		if(newValue[0] == '1')
			g_bAutoRespawn = true;
		else
			g_bAutoRespawn = false;
	}	
	if(convar == g_hAllowCheckpoints)
	{
		if(newValue[0] == '1')
			g_bAllowCheckpoints = true;
		else
			g_bAllowCheckpoints = false;
	}
	if(convar == g_hRadioCommands)
	{
		if(newValue[0] == '1')
			g_bRadioCommands = true;
		else
			g_bRadioCommands = false;
	}	
	if(convar == g_hcvarRestore)
	{
		if(newValue[0] == '1')
			g_bRestore = true;			
		else
			g_bRestore = false;
	}
	if(convar == g_hPlayerSkinChange)
	{
		if(newValue[0] == '1')
		{
			g_bPlayerSkinChange = true;
			for (new i = 1; i <= MaxClients; i++)
				if (1 <= i <= MaxClients && IsClientInGame(i) && i != g_iBot2 && i != g_iBot)	
				{
					SetEntPropString(i, Prop_Send, "m_szArmsModel", g_sArmModel);
					SetEntityModel(i,  g_sPlayerModel);
				}
		}
		else
			g_bPlayerSkinChange = false;
	}	
	if(convar == g_hPointSystem)
	{
		if(newValue[0] == '1')
		{
			g_bPointSystem = true;		
			for (new i = 1; i <= MaxClients; i++)
				if (1 <= i <= MaxClients && IsClientInGame(i))				
					CreateTimer(0.0, SetClanTag, i,TIMER_FLAG_NO_MAPCHANGE);					
		}
		else
		{
			for (new i = 1; i <= MaxClients; i++)
				if (1 <= i <= MaxClients && IsClientInGame(i))
				{
					Format(g_pr_rankname[i], 32, "");
					CreateTimer(0.0, SetClanTag, i,TIMER_FLAG_NO_MAPCHANGE);
				}
			g_bPointSystem = false;
		}
	}	
	if(convar == g_hForceJumpPenalty)
	{
		if(newValue[0] == '1')
		{
			g_bForceJumpPenalty = true;		
			for (new i = 1; i <= MaxClients; i++)
				if (1 <= i <= MaxClients && IsClientInGame(i))				
					g_bJumpPenalty[i] = true;				
		}
		else
			g_bForceJumpPenalty = false;
	}		
	
	if(convar == g_hcvarNoBlock)
	{
		if(newValue[0] == '1')
		{
			g_bNoBlock = true;
			for(new client = 1; client <= MAXPLAYERS; client++)
				if (IsValidEntity(client))
					SetEntData(client, FindSendPropOffs("CBaseEntity", "m_CollisionGroup"), 2, 4, true);
					
		}
		else
		{	
			g_bNoBlock = false;
			for(new client = 1; client <= MAXPLAYERS; client++)
				if (IsValidEntity(client))
					SetEntData(client, FindSendPropOffs("CBaseEntity", "m_CollisionGroup"), 5, 4, true);
		}
	}
	
	if(convar == g_hCleanWeapons)
	{
		if(newValue[0] == '1')
		{
			decl String:szclass[32];
			g_bCleanWeapons = true;
			for (new i = 1; i <= MaxClients; i++)
			{
				if (1 <= i <= MaxClients && IsClientInGame(i) && IsPlayerAlive(i))
				{
					for(new j = 0; j < 4; j++)
					{
						new weapon = GetPlayerWeaponSlot(i, j);
						if(weapon != -1 && j != 2)
						{
							GetEdictClassname(weapon, szclass, sizeof(szclass));
							RemovePlayerItem(i, weapon);
							RemoveEdict(weapon);							
							new equipweapon = GetPlayerWeaponSlot(i, 2)
							if (equipweapon != -1)
								EquipPlayerWeapon(i, equipweapon); 
						}
					}
				}
			}
			
		}
		else
			g_bCleanWeapons = false;
	}
	
	if(convar == g_hEnforcer)
	{
		if(newValue[0] == '1')		
		{
			g_bEnforcer = true;
			ServerCommand("sm_cvar sv_enablebunnyhopping 1");
		}
		else
			g_bEnforcer = false;
	}	
	
	if(convar == g_hJumpStats)
	{
		if(newValue[0] == '1')		
			g_bJumpStats = true;
		else
			g_bJumpStats = false;
	}		
	
	if(convar == g_hAutoBhop)
	{
		if(newValue[0] == '1')		
		{		
			g_bAutoBhop = true;
			
			if(StrEqual(g_szMapTag[0],"surf") || StrEqual(g_szMapTag[0],"bhop") || StrEqual(g_szMapTag[0],"mg"))
			{
				g_bAutoBhop2=true;
				ServerCommand("sm plugins unload macrodox.smx");
			}
			else
				g_bAutoBhop2=false;
		}
		else
		{
			g_bAutoBhop = false;
			g_bAutoBhop2 = false;
			ServerCommand("sm plugins load macrodox.smx");
		}
	}		
	
	if(convar == g_hCountry)
	{
		if(newValue[0] == '1')
		{
			g_bCountry = true;
			for (new i = 1; i <= MaxClients; i++)
			{
				if (1 <= i <= MaxClients && IsClientInGame(i))
				{
					GetCountry(i);
					if (g_bPointSystem)
						CreateTimer(0.5, SetClanTag, i,TIMER_FLAG_NO_MAPCHANGE);
				}
			}
		}
		else
		{
			g_bCountry = false;
			if (g_bPointSystem)
				for (new i = 1; i <= MaxClients; i++)
					if (1 <= i <= MaxClients && IsClientInGame(i))				
						CreateTimer(0.5, SetClanTag, i,TIMER_FLAG_NO_MAPCHANGE);		
		}
	}	
	
	if(convar == g_hdist_good_multibhop)
		g_dist_good_multibhop = StringToFloat(newValue[0]);	
	
	if(convar == g_hdist_pro_multibhop)
		g_dist_pro_multibhop = StringToFloat(newValue[0]);			
	
	if(convar == g_hdist_leet_multibhop)
		g_dist_leet_multibhop = StringToFloat(newValue[0]);	
	
	if(convar == g_hdist_good_bhop)
		g_dist_good_bhop = StringToFloat(newValue[0]);
	
	if(convar == g_hdist_pro_bhop)
		g_dist_pro_bhop = StringToFloat(newValue[0]);		
	
	if(convar == g_hdist_leet_bhop)
		g_dist_leet_bhop = StringToFloat(newValue[0]);		

	if(convar == g_hdist_good_dropbhop)
		g_dist_good_dropbhop = StringToFloat(newValue[0]);
	
	if(convar == g_hdist_pro_dropbhop)
		g_dist_pro_dropbhop = StringToFloat(newValue[0]);		
	
	if(convar == g_hdist_leet_dropbhop)
		g_dist_leet_dropbhop = StringToFloat(newValue[0]);	

	if(convar == g_hdist_good_weird)
		g_dist_good_weird = StringToFloat(newValue[0]);
	
	if(convar == g_hdist_pro_weird)
		g_dist_pro_weird = StringToFloat(newValue[0]);		
	
	if(convar == g_hdist_leet_weird)
		g_dist_leet_weird = StringToFloat(newValue[0]);	
	
	if(convar == g_hdist_good_lj)
		g_dist_good_lj = StringToFloat(newValue[0]);
	
	if(convar == g_hdist_pro_lj)
		g_dist_pro_lj = StringToFloat(newValue[0]);
	
	if(convar == g_hdist_leet_lj)
		g_dist_leet_lj = StringToFloat(newValue[0]);
	
	if(convar == g_hBhopSpeedCap)
		g_fBhopSpeedCap = StringToFloat(newValue[0]);	
	if(convar == g_hPlayerpointsScale)
	{
		g_fPlayerpointsScale = StringToFloat(newValue[0]);
		g_pr_dyn_maxpoints = RoundToCeil((g_pr_mapcount*g_fPlayerpointsScale)*300+(((g_pr_mapcount*g_fPlayerpointsScale)*300)*0.3));
		g_pr_rank_Novice = RoundToCeil(g_pr_dyn_maxpoints * 0.001);  
		g_pr_rank_Scrub = RoundToCeil(g_pr_dyn_maxpoints * 0.03); 
		g_pr_rank_Rookie = RoundToCeil(g_pr_dyn_maxpoints * 0.12);  
		g_pr_rank_Skilled = RoundToCeil(g_pr_dyn_maxpoints * 0.45);  
		g_pr_rank_Expert = RoundToCeil(g_pr_dyn_maxpoints * 0.75);  
		g_pr_rank_Pro = RoundToCeil(g_pr_dyn_maxpoints * 1.1);  
		g_pr_rank_Elite = RoundToCeil(g_pr_dyn_maxpoints * 1.5); 
		g_pr_rank_Master = RoundToCeil(g_pr_dyn_maxpoints * 2.0); 
		g_pr_points_finished = g_pr_rank_Novice;
	}
	
	if(convar == g_hMaxBhopPreSpeed)
		g_fMaxBhopPreSpeed = StringToFloat(newValue[0]);	
		
	if(convar == g_hcvargodmode)
	{
		if(newValue[0] == '1')
			g_bgodmode = true;
		else
			g_bgodmode = false;
		for (new i = 1; i <= MaxClients; i++)
		{
			if (1 <= i <= MaxClients && IsClientInGame(i))
			{	
				if (g_bgodmode)
					SetEntProp(i, Prop_Data, "m_takedamage", 0, 1);
				else
					SetEntProp(i, Prop_Data, "m_takedamage", 2, 1);
			}
		}
	}
	
	if(convar == g_hReplayBotPlayerModel)
	{
		Format(g_sReplayBotPlayerModel,256,"%s", newValue[0]);
		PrecacheModel(newValue[0],true);
		if (g_iBot2 != -1)
			SetEntityModel(g_iBot2,  newValue[0]);
		if (g_iBot != -1)
			SetEntityModel(g_iBot,  newValue[0]);	
	}
	
	if(convar == g_hReplayBotArmModel)
	{
		Format(g_sReplayBotArmModel,256,"%s", newValue[0]);
		PrecacheModel(newValue[0],true);				
		if (g_iBot2 != -1)
				SetEntPropString(g_iBot2, Prop_Send, "m_szArmsModel", newValue[0]);
		if (g_iBot != -1)
				SetEntPropString(g_iBot, Prop_Send, "m_szArmsModel", newValue[0]);	
	}
	
	if(convar == g_hPlayerModel)
	{
		Format(g_sPlayerModel,256,"%s", newValue[0]);
		PrecacheModel(newValue[0],true);		
		if (!g_bPlayerSkinChange)
			return;
		for (new i = 1; i <= MaxClients; i++)
			if (1 <= i <= MaxClients && IsClientInGame(i) && i != g_iBot2 && i != g_iBot)	
				SetEntityModel(i,  newValue[0]);
	}
	
	if(convar == g_hArmModel)
	{
		Format(g_sArmModel,256,"%s", newValue[0]);
		PrecacheModel(newValue[0],true);			
		if (!g_bPlayerSkinChange)
			return;
		for (new i = 1; i <= MaxClients; i++)
			if (1 <= i <= MaxClients && IsClientInGame(i) && i != g_iBot2 && i != g_iBot)	
				SetEntPropString(i, Prop_Send, "m_szArmsModel", newValue[0]);
	}
	
	if(convar == g_hWelcomeMsg)
		Format(g_sWelcomeMsg,512,"%s", newValue[0]);
}