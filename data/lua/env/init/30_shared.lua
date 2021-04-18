local env = ...

local shared = {
	_internal = {
		channelID = env.threadID,
	},
}

local requestChannel = env.thread.getChannel("SHARED_REQUEST")
local responseChannel = env.thread.getChannel("SHARED_RESPONSE#" .. tostring(shared._internal.channelID))

--=== set meta tables ===--
debug.setFuncPrefix("[SHARED]")
dlog("Set metatables")

setmetatable(shared, {
	__index = function(_, index)
		requestChannel:push({
			request = "get",
			id = shared._internal.channelID,
			index = index,
		})
		
		return responseChannel:demand()
	end,
	__newindex = function(_, index, value)
		requestChannel:supply({
			request = "set",
			id = shared._internal.channelID,
			index = index,
			value = value,
		})
	end,
})


env.shared = shared
_G.shared = shared