--require("ssl")

print("--===== TEST1 START =====--")

local thread = require("love.thread")

local tt = thread.newThread("lua/core/terminal/testThread.lua")
tt:start()


print("--===== TEST1 END =====--")