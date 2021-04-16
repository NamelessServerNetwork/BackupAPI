--pre initializes the env for all threads

local threadName, mainThread = ...
local env = {}

--=== loadl devConf ===--
local devConf = loadfile("data/lua/devConf.lua")()
env.devConf = devConf

package.path = package.path .. ";" .. devConf.requirePath
package.cpath = package.cpath .. ";" .. devConf.cRequirePath

--=== set debug ===--
env.debug = loadfile("data/lua/env/debug.lua")(devConf, tostring(threadName) .. "[ENV_INIT]")


--=== set environment ===--
dlog("Load env")
loadfile("data/lua/env/env.lua")(env, mainThread)

--NOTE: "data/" is default path from here on


dlog("Loading libs")
env.fs = require("love.filesystem")
env.thread = require("love.thread")
env.ut = require("UT")

env.dl = loadfile("lua/libs/dataLoading.lua")(env)


dlog("Load shared")
local shared = loadfile("lua/env/shared.lua")(env, mainThread)
env.shared = shared

dlog("Initialize the environment")

debug.setLogPrefix(tostring(threadName))

dlog("Load dynamic env data")
env.dl.load({
	target = env, 
	dir = "lua/env/dynData", 
	name = "dynData", 
	structured = true,
	execute = true,
})


return env, shared