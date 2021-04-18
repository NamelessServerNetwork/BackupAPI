local env, shared = ...

log("Wait for threads to stop")

local threadRegistrationChannel = env.thread.getChannel("THREAD_REGISTRATION")
local programActiveChannel = env.thread.getChannel("PROGRAM_IS_RUNNING")

programActiveChannel:pop()
programActiveChannel:push(false)

while true do
	local thread = threadRegistrationChannel:pop()
	
	if thread == nil then break end
	
	if thread.thread:isRunning() then
		dlog("Waiting for thread to stop: " .. tostring(thread.name) .. "(" .. tostring(thread.thread) .. ")")
		if thread.wait ~= nil then --crash prevention in case the thread is dead already at this point.
			thread:wait()
		end
	end
end