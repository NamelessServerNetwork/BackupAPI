
--[[
local c = require("love.thread").getChannel("debug_write")

--c:push("test thread 1", "test2", "test3")
c:push("\n")
c:push("\n")
c:push("\n")
c:push("\n")
c:push("\n")
--c:push("test4")
]]

local env = loadfile("data/lua/env/envInit.lua")("[TERMINAL_TEST_THREAD#1]")

print("--===== TERMINAL TEST THREAD#1 START ======--")

print("test1", "test2", "test3")
io.write("test4")
io.write("test5")
io.write("test6")
io.flush()
print("test7", "test8", "test9")

print("--===== TERMINAL TEST THREAD#1 END ======--")