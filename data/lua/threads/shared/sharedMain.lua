log("Starting sharing manager")

local shared = {} --all shared data

local responseChannels = {}

local requestChannel = env.thread.getChannel("SHARED_REQUEST")
local testThreadsActiveChannel = env.thread.getChannel("TEST_THREAD_ACTIVE")

while testThreadsActiveChannel:peek() do
	local request = requestChannel:demand(1)
	
	if request ~= nil then
		if responseChannels[request.id] == nil then
			responseChannels[request.id] = env.thread.getChannel("SHARED_RESPONSE#" .. tostring(request.id))
		end
		
		if request.request == "get" then
			responseChannels[request.id]:push(shared[request.index])
		elseif request.request == "set" then
			shared[request.index] = request.value
		end
	end
end