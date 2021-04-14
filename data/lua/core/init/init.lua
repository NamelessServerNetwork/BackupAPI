local version, args = ...

--===== parse args/defConf =====--
local args = loadfile("data/lua/core/init/parseArgs.lua")(args, version) --parse args

--===== pre initialisation =====--
local env, shared = loadfile("data/lua/env/envInit.lua")("[MAIN]", true)

--NOTE: "data/" is now default path for loadfile.

--===== start initialisation =====--
log("Start initialization")
debug.setFuncPrefix("[INIT]")

dlog("Initialize main env")
local mainTable = loadfile("lua/core/main.lua")()
for i, c in pairs(mainTable) do
	env[i] = c
end

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

log("Initialization done")

--os.exit(0)

loadfile("lua/core/init/test.lua")(env)

return true, 0