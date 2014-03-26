ConnectToGlobalDB()
{
	decl String:szError[255];
	new Handle:kv = INVALID_HANDLE;
	kv = CreateKeyValues("");
	KvSetString(kv, "driver", "mysql");
	KvSetString(kv, "host", "priv.net");
	KvSetString(kv, "port", "priv");
	KvSetString(kv, "database", "priv");
	KvSetString(kv, "user", "priv");
	KvSetString(kv, "pass", "priv");      
      
	g_hDbGlobal = SQL_ConnectCustom(kv, szError, sizeof(szError), true);      
	if (g_hDbGlobal == INVALID_HANDLE && g_bGlobalDB)
	{
		LogError("[KZ] Unable to connect to global database (%s)", szError);
	}
	else
		g_BGlobalDBConnected=true;
}

public Action:SecretTimer(Handle:timer)
{
//priv
}
