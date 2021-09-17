local devConf = {
	userLoginDatabasePath = "users.sqlite3",
	
	requirePath = "data/lua/libs/?.lua;data/lua/libs/thirdParty/?.lua;/home/noname/.luarocks/share/lua/5.1/?.lua",
	cRequirePath = "data/bin/libs/?.so;/home/noname/.luarocks/lib/lua/5.1/?.so",
	terminalPath = "lua/core/terminal/",
	
	sleepTime = .1, --the time the terminal is waiting for an input. this affect the CPU time as well as the time debug messanges needs to be updated.
	terminalSizeRefreshDelay = 1,

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
	
	sqlite = {
		busyWaitTime = .05, --defines the time the system waits every time the sqlite DB is busy.
	},
	
	onReload = {
		core = true,
	},
	
	debug = {
		logDirectInput = false,
		logInputEvent = false,
		
		logLevel = {
			debug = true,
			lowLevelDebug = false,
			threadDebug = false,
			threadEnvInit = false,
			eventDebug = false,
			lowLevelEventDebug = false,
			lowLevelSharingLog = false,
		},
	},
}

return devConf
