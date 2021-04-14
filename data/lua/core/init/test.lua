--require("ssl")
local env, shared = ...

print("--===== TEST1 START =====--")

local thread = require("love.thread")
local fs = require("love.filesystem")

local tt = thread.newThread("lua/core/terminal/testThread.lua")

local stt1 = thread.newThread("lua/env/test/sharedTestThread1.lua")
local stt2 = thread.newThread("lua/env/test/sharedTestThread2.lua")
local sct = thread.newThread("lua/env/test/sharedControlThread.lua")

--[[
tt:start()

stt1:start()
stt2:start()
sct:start()
]]

env.dl = loadfile("lua/libs/dataLoading.lua")(env, shared)

local files = env.dl.executeDir("lua/core/onReload", "reload scripts")



print("--===== TEST1 END =====--")