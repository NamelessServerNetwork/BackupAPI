local env, shared = ...

print("--===== RELOAD =====--")
debug.setFuncPrefix("[RELOAD]")

loadfile("lua/core/init/test.lua")(env, shared)

env.dl.executeDir("lua/core/onReload", "reload core")
env.dl.executeDir("lua/env/onReload", "reload env")
env.dl.executeDir("lua/onReload", "reload general")
env.dl.executeDir("onReload", "reload finish")