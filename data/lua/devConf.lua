local devConf = {
	requirePath = "data/lua/libs/?.lua;data/lua/libs/thirdParty/?.lua",
	cRequirePath = "data/bin/libs/?.so",
	terminalPath = "lua/core/terminal/",
	
	sleepTime = .1, --the time the terminal is waiting for an input. this affect the CPU time as well as the time debug messanges needs to be updated.
	
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
	
	onReload = {
		core = true,
	},
	
	debug = {
		debugLog = true,
		lowDebugLog = false,
		threadDebugLog = false,
		threadEnvInitLog = false,
		eventDebugLog = false,
		lowEventDebugLog = false,
	},
}

return devConf