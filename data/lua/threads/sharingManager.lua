log("Starting sharing manager")

local sharedData = {
	
	t1 = {
		t2 = {
			ts = "test",
			tn = 3,
		},

		testValue = "TEST",
	},
	
} --all shared data
local lockTable = {}

local _internal = {}

local responseChannels = {}
local requestChannel = env.thread.getChannel("SHARED_REQUEST")

local ldlog = debug.sharingThread
local generateIndexString = getmetatable(env.shared)._internal.generateIndexString

--===== local functions =====--
local function getValue(source, indexTable)
	local value = source
	local originValue = source

	for _, index in ipairs(indexTable) do
		if type(value) == "table" then
			originValue = value
			value = value[index]
		else
			return nil
		end
	end

	return value, originValue
end

--===== internal functions =====--
function _internal.execRequest(request)
	if request ~= nil then
		if responseChannels[request.id] == nil then
			responseChannels [request.id] = env.thread.getChannel("SHARED_RESPONSE#" .. tostring(request.id))
		end

		if request.request == "get" then
			if env.devConf.debug.logLevel.sharingThread then --double check to prevent string concatenating process if debug output is disabled.
				ldlog("GET request (CID: " .. tostring(request.id) .. "); index: '" .. string.sub(generateIndexString(request.indexTable), 1, -2) .. "'")
			end

			local returnValue = getValue(sharedData, request.indexTable)

			if type(returnValue) == "table" then
				returnValue = {
					address = tostring(returnValue),
				}
			end

			responseChannels[request.id]:push(returnValue)
		elseif request.request == "set" then
			local indexString
			if env.devConf.debug.logLevel.sharingThread then --double check to prevent string concatenating process if debug output is disabled.
				indexString = generateIndexString(request.indexTable) .. tostring(request.index)
				ldlog("SET request (CID: " .. tostring(request.id) .. "); index: " .. indexString .. "; new value: '" .. tostring(request.value) .. "'")
			end

			local lock = getValue(lockTable, request.indexTable)[request.index]

			if lock ~= nil and lock.locked then
				ldlog("Index is locked. Add request to queue: SET (CID: " .. tostring(request.id) .. "); index: " .. indexString)
				table.insert(lock.execQueue, request)
			else
				local target = getValue(sharedData, request.indexTable)
				target[request.index] = request.value		
				responseChannels[request.id]:push(true)
			end
		elseif request.request == "call" then
			_internal.execCallRequest(request)
		elseif request.request == "dump" then
			log("Dumping shared table:\n" .. env.tostring(sharedData))
		elseif request.request == "dump_lockTable" then
			log("Dumping lockTable:\n" .. env.tostring(lockTable))
		elseif request.request == "stop" then --debug
			ldlog("Stop sharing manager")
			env.stop()
		end
	end
end

function _internal.execCallRequest(request)
	ldlog("Executing call order: " .. request.order .. "; thread: " .. request.id)

	local success, returnTable = false, {}

	if request.order == "test" then
		log("Sharing table test call")
		success = true
	elseif request.order == "dump" then
		log("Dumping shared table: '" .. string.sub(generateIndexString(request.indexTable), 1, -2) .. "': " .. env.tostring(getValue(sharedData, request.indexTable)))
		success = true
	elseif request.order == "get" then
		returnTable.value = getValue(sharedData, request.indexTable)
		success = true
	elseif request.order == "lock" then
		local lock = lockTable
		for _, index in ipairs(request.indexTable) do
			if lock[index] == nil then
				lock[index] = {}
			end
			lock = lock[index]
		end
		lock.locked = true
		lock.execQueue = {}

		success = true
	elseif request.order == "unlock" then
		local lock = getValue(lockTable, request.indexTable)

		lock.locked = nil

		while lock.execQueue[1] ~= nil do
			if lock.locked then
				break
			end

			_internal.execRequest(lock.execQueue[1])
			table.remove(lock.execQueue, 1)
		end

		success = true
	else
		returnTable.error = "No valid order"
	end
	if not success then
		warn("Could not successfully execute call order: " .. request.order .. "; thread: " .. tostring(request.id) .. "; error: " .. env.tostring(returnTable.error) .. "\nFull returnTable: ".. env.tostring(returnTable) .. "\nFull order request: " .. env.tostring(request))
	end
	returnTable.success = success
	responseChannels[request.id]:push(returnTable)
end

local function update()
	local request = requestChannel:demand(1)
	
	_internal.execRequest(request)
end