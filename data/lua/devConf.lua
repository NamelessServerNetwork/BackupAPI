local devConf = {
	userLoginDatabasePath = "users.sqlite3",
	
	requirePath = "data/lua/libs/?.lua;data/lua/libs/thirdParty/?.lua;/home/noname/.luarocks/share/lua/5.1/?.lua",
	cRequirePath = "data/bin/libs/?.so;/home/noname/.luarocks/lib/lua/5.1/?.so",
	terminalPath = "lua/core/terminal/",
	
	sleepTime = .1, --the time the terminal is waiting for an input. this affect the CPU time as well as the time debug messanges needs to be updated.
	terminalSizeRefreshDelay = 1,

	devMode = true,

	dateFormat = "%X",
	--dateFormat = "%Y-%m-%d-%H-%M-%S",

	http = {
		defaultRequestFormat = "lua-table",
		defaultResponseFormat = "lua-table",
	},
	
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
		logfile = "./logs/dams.log",

		logDirectInput = false,
		logInputEvent = false,
		
		logLevel = {
			debug = true,
			lowLevelDebug = false,
			threadDebug = false,
			threadEnvInit = false, --print env init debug from every thread.
			eventDebug = false,
			lowLevelEventDebug = false,
			lowLevelSharingLog = true,

			require = false,
			loadfile = false,

			dataLoading = false, --dyn data loading debug.
			dataExecution = false, --dyn data execution debug.
			lowDataLoading = false, --low level dyn data loading debug.
			lowDataExecution = false, --low dyn data execution debug.
		},
	},
}

return devConf
