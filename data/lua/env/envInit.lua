--pre initializes the env for all threads

local devConf, threadName = ...
local env = {}

--=== set debug ===--
env.debug = loadfile("data/lua/env/debug.lua")(devConf, tostring(threadName) .. "[ENV_INIT]")

--=== set environment ===--
dlog("Initialize the environment")
loadfile("data/lua/env/env.lua")(env)

debug.setLogPrefix(tostring(threadName))

dlog("Setting up require paths")
package.path = package.path .. ";" .. devConf.requirePath
package.cpath = package.cpath .. ";" .. devConf.cRequirePath
ldlog("New lua require paths: " .. package.path)
ldlog("New C require paths: " .. package.cpath)

return env