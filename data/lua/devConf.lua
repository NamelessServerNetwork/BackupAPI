local devConf = {
	requirePath = "data/lua/libs/?.lua;data/lua/libs/thirdParty/?.lua;/usr/local/lib/lua/5.1/?.so",
	cRequirePath = "",
	
	devMode = true,
	
	terminalCommands = {
		forceMainTerminal = "_MT",
	},
	
	debug = {
		debugLog = true,
		lowDebugLog = true,
	},
}

return devConf