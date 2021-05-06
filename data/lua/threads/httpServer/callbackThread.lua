ldlog("CALLBACK THREAD START")

local callbackStream = env.thread.getChannel("HTTP_CALLBACK_STREAM#" .. tostring(env.getThreadInfos().id))

local resHeaders = {}
local resData = {}

local headers = env.initData.args

local function executeUserOrder()
	local func, err
	
	if headers.action ~= nil then
		func, err = loadfile("userActions/" .. headers.action .. ".lua")
	end
	
	if func ~= nil then
		resData.returnValue = func()
		resHeaders.success = "true"
	else
		warn("Recieved unknown user action request: " .. tostring(headers.action))
		resHeaders.success = "false"
		resHeaders.error = "Invalid user action"
	end
end

do 
	local suc, err = xpcall(executeUserOrder, debug.traceback)
	if suc ~= true then
		debug.err(suc, err)
		resHeaders.success = "false"
		resHeaders.error = "User script crash"
		resData.scriptError = tostring(err)
	end
end


do --debug
	if type(shared.requestCount) ~= "number" then
		shared.requestCount = 0
	end
	shared.requestCount = shared.requestCount +1
	resData.requestCount = tostring(shared.requestCount) .. " (debug)"
end


callbackStream:push({headers = resHeaders, data = resData})
ldlog("CALLBACK THREAD END")
env.stop()