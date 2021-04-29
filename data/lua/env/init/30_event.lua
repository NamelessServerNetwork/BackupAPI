local env = ...

local eventQueue = env.thread.getChannel("EVENT_QUEUE_MAIN")

local event = {
	
}

function event.push(eventType, data)
	eventQueue:push({eventType = eventType, data = data})
end

env.event = event
_G.event = event