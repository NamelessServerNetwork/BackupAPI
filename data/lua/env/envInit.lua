--pre initializes the env for all threads

local initData = ...
local env = {
	--threadName = initData.name,
	mainThread = initData.mainThread,
	initData = initData,
}
local _internal = {
	threadID = initData.id,
	threadName = initData.name,
	threadIsActive = true,
}
setmetatable(env, {_internal = _internal})
_G.env = env

--=== loadl devConf ===--
local devConf = loadfile("data/lua/devConf.lua")()
env.devConf = devConf

package.path = devConf.requirePath .. ";" .. package.path
package.cpath = devConf.cRequirePath .. ";" .. package.cpath

--=== set debug ===--
env.debug = loadfile("data/lua/env/debug.lua")(devConf, tostring(_internal.threadName) .. "[ENV_INIT]")

--=== disable env init logs for non main threads ===--
local orgLog = env.debug.log
local orgDlog = env.debug.dlog
local orgLdlog = env.debug.ldlog
if not env.mainThread and not env.devConf.debug.logLevel.threadEnvInit then
	_G.log = function() end
	_G.dlog = function() end
	_G.ldlog = function() end
end

--=== set environment ===--
dlog("Load coreEnv")
loadfile("data/lua/env/coreEnv.lua")(env, env.mainThread)

--NOTE: "data/" is default path from here on

dlog("Loading core libs")
env.fs = require("love.filesystem")
env.ut = require("UT")
env.dl = loadfile("lua/libs/dataLoading.lua")(env)

dlog("Initialize the environment")
debug.setLogPrefix(tostring(_internal.threadName))

env.dl.executeDir("lua/env/init", "envInit")

dlog("Load dynamic env data")

env.dl.load({
	target = env, 
	dir = "lua/env/dynData", 
	name = "dynData", 
	structured = true,
	execute = true,
})

--env.dl.loadDir("lua/env/dynData/test", {}, "dynData")

--=== enable logs again ===--
_G.log = orgLog
_G.dlog = orgDlog
_G.ldlog = orgLdlog

return env, shared