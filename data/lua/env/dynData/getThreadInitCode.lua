local env = ...

local serialize = require("ser")

return function(code, initData)
	local initData = env.ut.parseArgs(initData, {})
	initData.mainThread = false
	
	local newCode = [[
		local env, shared = loadfile('data/lua/env/envInit.lua')(]] .. env.serialize(initData) .. [[)
		
		]] .. code .. [[
		
		if type(update) == 'function' then
			while env.isRunning() do
				local suc, err = xpcall(update, debug.traceback)
				
				if suc ~= true then
					debug.fatal(suc, err)
				end
			end
		end
	]]
	
	return newCode
end