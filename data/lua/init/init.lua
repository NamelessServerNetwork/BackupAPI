local version, args = ...

--===== parse args/defConf =====--
local args = loadfile("data/lua/init/parseArgs.lua")(args, version) --parse args

local devConf = loadfile("data/lua/devConf.lua")()
if args.devMode then devConf.devMode = true end

--===== pre initialisation =====--
local env = loadfile("data/lua/env/envInit.lua")(devConf, "[MAIN]")

--NOTE: "data/" is now default path for loadfile.

--===== start initialisation =====--
log("Start initialization")
debug.setFuncPrefix("[INIT]")

dlog("Initialize main env")
env = loadfile("lua/core/main.lua")()
env.devConf = devConf

dlog("Setting up require paths")
package.path = package.path .. ";" .. devConf.requirePath
package.path = package.path .. ";" .. devConf.cRequirePath
ldlog("New lua require paths: " .. package.path)
ldlog("New C require paths: " .. package.cpath)

dlog("Loading libs")
env.fs = require("love.filesystem")

env.ut = require("lua.libs.UT")

env.dl = loadfile("lua/libs/dataLoading.lua")(env)

--=== load core files ===--
dlog("Loading core files")
loadfile("lua/core/terminal.lua")(env)
loadfile("lua/core/shutdown.lua")(env)

loadfile("lua/init/test.lua")(env)

--=== load dynamic data ===--
env.dl.load(env.commands, "commands", "commands")

local function t()
	debug.setFuncPrefix("[TEST]", false, false)
	log("T")
end
t()


log("Initialization done")

--os.exit(0)

return true, 0