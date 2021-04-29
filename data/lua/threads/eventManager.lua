log("Starting event manager")

local eventChannels = {}

local eventQueue = env.thread.getChannel("EVENT_QUEUE_MAIN")

local function newEvent()
	local request = eventQueue:demand(1)
	
	if request ~= nil then
		
	end
end

local function update()
	newEvent()
end