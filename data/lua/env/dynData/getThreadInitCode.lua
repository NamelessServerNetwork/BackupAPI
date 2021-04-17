return function(name)
	local code = [[
		local env, shared = loadfile('data/lua/env/envInit.lua')('[]] .. tostring(name) .. [[]')
	]]
	
	return code
end