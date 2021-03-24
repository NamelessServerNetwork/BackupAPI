local version, args = ...

--===== parse args/defConf =====--
local args = loadfile("data/lua/init/parseArgs.lua")(args, version) --parse args

local devConf = loadfile("data/lua/devConf.lua")()
if args.devMode then devConf.devMode = true end

--===== pre initialisation =====--
local env = loadfile("data/lua/env/preInit.lua")(devConf.devMode, "[MAIN]")

--NOTE: "data/" is now default path for loadfile.

--===== start initialisation =====--
log("Start initialization")

debug.setFuncPrefix("[INIT]")

--[[
dlog("Initialize main env")
env = loadfile("lua/core/main.lua")()
]]

dlog("Setting up require paths")
package.path = package.path .. ";" .. devConf.requirePath
package.path = package.path .. ";" .. devConf.cRequirePath
dlog("New lua require paths: " .. package.path)
dlog("New C require paths: " .. package.cpath)

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
--dlog("Loading dynamic data")



log("Initialization done")

os.exit(0)

return true, 0