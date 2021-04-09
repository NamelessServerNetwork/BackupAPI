--require("ssl")

print("--===== TEST1 START =====--")

local thread = require("love.thread")

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

print("--===== TEST1 END =====--")