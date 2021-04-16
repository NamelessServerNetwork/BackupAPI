local env, shared = ...

return function(dir, name)
	local suc, file = pcall(io.open, "data/" .. dir, "r")
	local threadCode = "local env, shared = loadfile('data/lua/env/envInit.lua')('[" .. tostring(name) .. "]')"
	
	dlog("Load thread from file")
	
	if type(file) == "userdata" then
		threadCode = threadCode .. file:read("*all")
		file:close()
		return env.thread.newThread(threadCode)
	else
		warn("Cant load thread from file: (" .. dir .. ")")
		return false, "File not found"
	end
end