local env, shared = ...

print("--===== RELOAD =====--")
debug.setFuncPrefix("[RELOAD]")

--loadfile("data/lua/core/init/test.lua")(env, shared)

env.dl.executeDir("lua/core/onReload", "RELOAD_core")
env.dl.executeDir("lua/env/onReload", "RELOAD_env")
env.dl.executeDir("lua/onReload", "RELOAD_general")
env.dl.executeDir("onReload", "RELOAD_finish")