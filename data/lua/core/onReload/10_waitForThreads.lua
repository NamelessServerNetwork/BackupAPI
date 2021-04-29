local env, shared = ...

log("Wait for threads to stop")

local activeThreadsChannel = env.thread.getChannel("ACTIVE_THREADS")
local programActiveChannel = env.thread.getChannel("PROGRAM_IS_RUNNING")

programActiveChannel:pop()
programActiveChannel:push(false)

while true do
	local thread = activeThreadsChannel:pop()
	
	if thread == nil then break end
	
	if thread.thread:isRunning() then
		dlog("Waiting for thread to stop: " .. tostring(thread.name) .. "(" .. tostring(thread.thread) .. ")")
		
		pcall(function() thread.thread:wait() end)
	end
end