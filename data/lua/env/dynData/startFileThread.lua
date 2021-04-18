local env, shared = ...

return function(dir, name)
	local thread, err = env.newFileThread(dir, name)
	
	if thread ~= false then
		local _, suc = xpcall(thread.start, debug.traceback, thread)
		dlog("Starting thread: " .. tostring(name) .. " (" .. tostring(thread) .. "): " .. tostring(suc))
		return suc, thread
	else
		warn("Cant start thread: " .. err)
	end
end