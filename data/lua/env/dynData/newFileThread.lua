local env, shared = ...

return function(dir, name)
	local file = io.read(dir, "r")
	
	env.thread.newThread(file, name)
	
	file:close()
end