log("--===== SHARED TEST THREAD#1 START ======--")

local channel = env.thread.getChannel("test1")

local t1 = {}
setmetatable(t1, {test = "meta_test1"})

dlog(channel:push("t1"))
dlog(channel:push(2))
dlog(channel:push({test = "t3"}))
dlog(channel:push(t1))

log("--===== SHARED TEST THREAD#1 END ======--")