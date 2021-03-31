--pre initializes the env for all threads

local threadName, mainThread = ...
local env = {}

--=== loadl devConf ===--
local devConf = loadfile("data/lua/devConf.lua")()
env.devConf = devConf

--=== set debug ===--
env.debug = loadfile("data/lua/env/debug.lua")(devConf, tostring(threadName) .. "[ENV_INIT]")
loadfile("data/lua/env/env.lua")(env, mainThread)

--=== set environment ===--
dlog("Initialize the environment")

debug.setLogPrefix(tostring(threadName))

dlog("Setting up require paths")
package.path = package.path .. ";" .. devConf.requirePath
package.cpath = package.cpath .. ";" .. devConf.cRequirePath
ldlog("New lua require paths: " .. package.path)
ldlog("New C require paths: " .. package.cpath)

return env