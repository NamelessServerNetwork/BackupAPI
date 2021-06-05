log("--===== SHARED TEST THREAD#1 START ======--")

--[[
local thread = env.newFileThread("lua/threads/test/shared/sharedTestThread1.lua", "SharedTestThread#1")

local channel = env.thread.getChannel("test1")

local t1 = {}
setmetatable(t1, {test = "meta_test1"})

dlog(channel:push("t1"))
dlog(channel:push(2))
dlog(channel:push({test = "t3"}))
dlog(channel:push(t1))
dlog(channel:push(thread))
]]

--shared.testVal1 = {test = "T1"}
--shared.testTable1 = {tt = {test = "TT content 1"}}

shared.testTable2 = {}
shared.testTable2.test = "test table test value"

log("--===== SHARED TEST THREAD#1 END ======--")