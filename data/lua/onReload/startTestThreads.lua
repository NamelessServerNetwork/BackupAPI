local env, shared = ...

log("--===== Start test threads =====--")

dlog(env.startFileThread("lua/testThreads/terminalTestThread1.lua", "TerminalTestThread#1"))
