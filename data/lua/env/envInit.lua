--pre initializes the env for all threads

local threadName, mainThread = ...
local env = {
	threadName = threadName,
	mainThread = mainThread,
}

--=== loadl devConf ===--
local devConf = loadfile("data/lua/devConf.lua")()
env.devConf = devConf

package.path = package.path .. ";" .. devConf.requirePath
package.cpath = package.cpath .. ";" .. devConf.cRequirePath

--=== set debug ===--
env.debug = loadfile("data/lua/env/debug.lua")(devConf, tostring(threadName) .. "[ENV_INIT]")

--=== disable env init logs for non main threads ===--
local orgLog = env.debug.log
local orgDlog = env.debug.dlog
local orgLdlog = env.debug.ldlog
if not mainThread and not env.devConf.debug.threadEnvInitLog then
	_G.log = function() end
	_G.dlog = function() end
	_G.ldlog = function() end
end

--=== set environment ===--
dlog("Load coreEnv")
loadfile("data/lua/env/coreEnv.lua")(env, mainThread)

--NOTE: "data/" is default path from here on

dlog("Loading core libs")
env.fs = require("love.filesystem")
env.ut = require("UT")
env.dl = loadfile("lua/libs/dataLoading.lua")(env)

dlog("Initialize the environment")
debug.setLogPrefix(tostring(threadName))

env.dl.executeDir("lua/env/init", "envInit")

dlog("Load dynamic env data")
env.dl.load({
	target = env, 
	dir = "lua/env/dynData", 
	name = "dynData", 
	structured = true,
	execute = true,
})

--=== enable logs again ===--
_G.log = orgLog
_G.dlog = orgDlog
_G.ldlog = orgLdlog


return env, shared