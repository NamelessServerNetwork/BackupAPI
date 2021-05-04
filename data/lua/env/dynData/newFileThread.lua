local env, shared = ...

local idChannel = env.thread.getChannel("GET_THREAD_ID")
local threadRegistrationChannel = env.thread.getChannel("THREAD_REGISTRATION")

return function(dir, name, args)
	if type(name) == "string" then name = "[" .. name .. "]" end
	local suc, file = pcall(io.open, "data/" .. dir, "r")
	local threadID = idChannel:push(name); idChannel:pop()
	local threadCode = env.getThreadInitCode(file:read("*all"), {name = name, id = threadID, args = args})
	file:close()
	
	ldlog("Load thread from file")
	
	if type(file) == "userdata" then
		local thread
		thread = env.thread.newThread(threadCode)
		
		threadRegistrationChannel:push({
			thread = thread,
			name = name,
			id = threadID,
		})
		
		return thread, threadID
	else
		warn("Cant load thread from file: (" .. dir .. ")")
		return false, "File not found"
	end
end