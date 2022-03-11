log("Starting sharing manager")

local shared = {
	test = "DEFAULT TEST VALUE",
	t1 = {
		t2 = {
			test = "DEFAULT TEST VALUE",
		},
	},
} --all shared data


local responseChannels = {}

local requestChannel = env.thread.getChannel("SHARED_REQUEST")

local ldlog = debug.lowLevelSharingLog 

local function update()
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

			
		elseif request.request == "dump" then
			ldlog("Dumping shared table")
			log(env.lib.ut.tostring(shared))
		elseif request.request == "stop" then --debug
			ldlog("Stop sharing manager")
			env.stop()
		end
	end
end