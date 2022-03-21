local env = ...

local shared = {
}
local _internal = {
	channelID = env.getThreadInfos().id,
}
--setmetatable(shared, {_internal = _internal})

local requestChannel = env.thread.getChannel("SHARED_REQUEST")
local responseChannel = env.thread.getChannel("SHARED_RESPONSE#" .. tostring(_internal.channelID))

local ldlog = debug.sharingDebug

function _internal.generateIndexString(indexTable) --for debugging purpose
	local indexString = ""
	for _, index in ipairs(indexTable) do
		indexString = indexString .. tostring(index) .. "."
	end
	return indexString
end

function _internal.index(sharedTable, index, internalRun)
	if env.devConf.debug.logLevel.sharingDebug then  --double check to prevent string concatenating process if debug output is disabled.
		ldlog("Get value: " .. _internal.generateIndexString(getmetatable(sharedTable).indexTable or {}) .. tostring(index))
	end

	local returnValue	
	local metatable = getmetatable(sharedTable)
	local newIndexTable = {}

	if metatable.indexTable ~= nil then
		for _, i in ipairs(metatable.indexTable) do
			table.insert(newIndexTable, i)
		end
		table.insert(newIndexTable, index)
	else
		newIndexTable = {index}
	end
	
	local function getValue()
		requestChannel:push({
			request = "get",
			id = _internal.channelID,
			indexTable = newIndexTable,
		})
		return responseChannel:demand()
	end

	returnValue = getValue()

	if type(returnValue) == "table" then
		local tostringValue = "shared_table: " .. string.sub(returnValue.address, 8)

		returnValue = setmetatable({}, {
			indexTable = newIndexTable,
			__index = _internal.index,
			__newindex = _internal.newindex,
			__tostring = function(self, a1, a2) --BUG: does return the wrong value if the shared table was changed. unfixable?
				return tostringValue
			end,
			__call = _internal.call,
		})
	end

	return returnValue
end

function _internal.newindex(sharedTable, index, value)
	metatable = getmetatable(sharedTable)

	if env.devConf.debug.logLevel.sharingDebug then  --double check to prevent string concatenating process if debug output is disabled.
		ldlog("Set value: " .. _internal.generateIndexString(getmetatable(sharedTable).indexTable or {}) .. tostring(index))
	end

	requestChannel:supply({
		request = "set",
		id = _internal.channelID,
		indexTable = metatable.indexTable or {},
		index = index,
		value = value,
	})

	responseChannel:demand() --wait till new value is actually written.
end

function _internal.call(sharedTable, ...)
	local args = {...}
	local order = args[1]
	local responseTable, returnValue

	requestChannel:push({
		request = "call",
		id = _internal.channelID,
		indexTable = getmetatable(sharedTable).indexTable,
		order = order,
	})

	responseTable = responseChannel:demand()

	if order == "get" then
		returnValue = responseTable.value
	else
		if responseTable.success then
			returnValue = true
		else
			returnValue = false
		end
	end

	
	return returnValue, responseTable.error
end

--=== set meta tables ===--
debug.setFuncPrefix("[SHARED]")
dlog("Set metatables")

setmetatable(shared, {
	_internal = _internal,
	__index = _internal.index,
	__newindex = _internal.newindex,
	__tostring = function()
		return "sharing_table"
	end,
	__call = _internal.call,
})


env.shared = shared
--_G.shared = shared