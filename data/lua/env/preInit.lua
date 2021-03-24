--pre initializes the env for all threads

local devMode, threadName = ...
local env = {}

--=== set debug ===--
env.debug = loadfile("data/lua/env/debug.lua")(devMode, tostring(threadName) .. "[PRE_INIT]")

--=== set environment ===--
dlog("Initialize the environment")
loadfile("data/lua/env/env.lua")(env)

debug.setLogPrefix(tostring(threadName))

return env