local env = ...

local idChannel = env.thread.getChannel("GET_THREAD_ID")

env.threadID = idChannel:push(env.threadName)
idChannel:pop()