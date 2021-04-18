log("Starting sharing manager")

local shared = {test = "T1"} --all shared data

local responseChannels = {}

local requestChannel = env.thread.getChannel("SHARED_REQUEST")

while env.isRunning() do
	local request = requestChannel:demand(1)
	
	if request ~= nil then
		if responseChannels[request.id] == nil then
			responseChannels[request.id] = env.thread.getChannel("SHARED_RESPONSE#" .. tostring(request.id))
		end
		
		if request.request == "get" then
			ldlog("GET request (CID: " .. tostring(request.id) .. "): " .. tostring(request.index))
			responseChannels[request.id]:push(shared[request.index])
		elseif request.request == "set" then
			ldlog("SET request (CID: " .. tostring(request.id) .. "): " .. tostring(request.index) .. ": " .. tostring(request.value))
			shared[request.index] = request.value
		end
	end
end