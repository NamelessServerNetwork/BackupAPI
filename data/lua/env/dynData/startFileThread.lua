local env, shared = ...

return function(dir, name)
	local thread, err = env.newFileThread(dir, name)
	
	if thread ~= false then
		return xpcall(thread.start, debug.traceback, thread)
	else
		warn("Cant start thread: " .. err)
	end
end