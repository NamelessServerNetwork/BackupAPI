local env, shared = ...

local threadRegistrationChannel = env.thread.getChannel("THREAD_REGISTRATION")

return function(dir, name)
	local suc, file = pcall(io.open, "data/" .. dir, "r")
	local threadCode = env.getThreadInitCode(name)
	
	dlog("Load thread from file")
	
	if type(file) == "userdata" then
		local thread
		threadCode = threadCode .. file:read("*all")
		file:close()
		thread = env.thread.newThread(threadCode)
		threadRegistrationChannel:push({
			thread = thread,
			name = name,
		})
		return thread
	else
		warn("Cant load thread from file: (" .. dir .. ")")
		return false, "File not found"
	end
end