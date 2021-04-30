local eventQueueMain = env.thread.getChannel("EVENT_QUEUE_MAIN")
local listnerRegistation = env.thread.getChannel("EVENT_LISTENER_REGISTRATION")
local eventQueueOwn = env.thread.getChannel("EVENT_QUEUE_THREAD#" .. tostring(env.getThreadID()))

debug.setFuncPrefix("[EVENT_API]")

local event = {}
local _internal = {
	listeners = {},
}
setmetatable(event, {_internal = _internal})

function event.listen(eventName, callback)
	ldlog("Register new event listener: " .. tostring(eventName) .. " to: " .. tostring(callback))
	if _internal.listeners[eventName] == nil then 
		_internal.listeners[eventName] = {}
	end
	_internal.listeners[eventName][callback] = true
	listnerRegistation:push({request = "listen", eventName = eventName, threadID = env.getThreadID()})
end
function event.ignore(eventName, callback)
	if _internal.listeners[eventName] ~= nil and _internal.listeners[eventName][callback] ~= nil then
		ldlog("Ignore event listener: " .. tostring(eventName) .. " for: " .. tostring(callback))
		_internal.listeners[eventName][callback] = nil
		for _ in pairs(_internal.listeners[eventName]) do return true end
		listnerRegistation:push({request = "ignore", eventName = eventName, threadID = env.getThreadID()})
	end
end

function event.push(eventName, data)
	eventQueueMain:push({eventName = eventName, data = data})
end

function event.pull(waitTime)
	local event
	
	if type(waitTime) == "number" then
		event = eventQueueOwn:demand(waitTime)
	end
	
	while eventQueueOwn:peek() ~= nil or event ~= nil do
		if event == nil then
			event = eventQueueOwn:pop()
		end
		
		if _internal.listeners[event.eventName] ~= nil then
			for callback in pairs(_internal.listeners[event.eventName]) do
				local suc, err = xpcall(callback, debug.traceback, event.data)
				
				if suc ~= true then
					debug.err("Failed executing event callback: " .. event.eventName .. " : " .. tostring(suc) .. "\n" .. err)
				end
			end
		end
		
		--=== cleanup ===--
		event = nil
	end
end

env.event = event
--_G.event = event