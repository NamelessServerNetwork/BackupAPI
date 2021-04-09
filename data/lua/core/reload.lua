local env, shared = ...

print("--===== RELOAD =====--")
debug.setFuncPrefix("[RELOAD]")

loadfile("lua/core/init/test.lua")(env, shared)