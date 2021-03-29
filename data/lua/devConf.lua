local devConf = {
	requirePath = "data/lua/libs/?.lua;data/lua/libs/thirdParty/?.lua",
	cRequirePath = "data/bin/libs/?.so",
	terminalPath = "lua/core/terminal/",
	
	devMode = true,
	
	terminal = {
		commands = {
			forceMainTerminal = "_MT",
		},
		keys = { --char codes for specific functions
			enter = 10,
			autoComp = 9,
			
		},
	},
	
	debug = {
		debugLog = true,
		lowDebugLog = true,
	},
}

return devConf