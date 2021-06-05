local version, args = ...

--===== parse args/defConf =====--
local args = loadfile("data/lua/core/parseArgs.lua")(args, version) --parse args

--===== pre initialisation =====--
local env, shared = loadfile("data/lua/env/envInit.lua")({name = "[MAIN]", mainThread = "[MAIN]", id = 0})

--NOTE: "data/" is now default path for loadfile.

--===== start initialisation =====--
log("Start initialization")
debug.setFuncPrefix("[INIT]")

dlog("Initialize main env")
local mainTable = loadfile("lua/core/mainTable.lua")()
for i, c in pairs(mainTable) do
	env[i] = c
end
env.version = version
env.args = args

--=== run dyn init ===--
env.dl.executeDir("lua/core/init", "INIT")

--=== load core files ===--
dlog("Loading core files")
loadfile(env.devConf.terminalPath .. "terminalManager.lua")(env)
loadfile("lua/core/shutdown.lua")(env)

--=== load dynamic data ===--

env.dl.load({
	target = env.commands, 
	dir = "commands", 
	name = "commands",
})

log("Initialize user init")
env.dl.executeDir("init", "USER_INIT")

log("Initialization done")

return true, env, shared