local env, shared = ...

log("--===== Start test threads =====--")

--env.startFileThread("lua/testThreads/terminalTestThread1.lua", "TerminalTestThread#1")

env.startFileThread("lua/testThreads/shared/sharedTestThread1.lua", "SharedTestThread#1")
env.startFileThread("lua/testThreads/shared/sharedTestThread2.lua", "SharedTestThread#2")
env.startFileThread("lua/testThreads/shared/sharedControlThread.lua", "SharedControlThread")

