ldlog("CALLBACK THREAD START")

local callbackStream = env.thread.getChannel("HTTP_CALLBACK_STREAM#" .. tostring(env.getThreadInfos().id))

local resHeaders = {}
local resData = {}

local requestData = env.initData.args

local function executeUserOrder()
	local func, err, requestedAction
		
	local _, request = env.lib.serialization.load(requestData.body)

	if type(request) ~= "table" then
		warn("Recieved invalid request: " .. request)
		resData.success = "false"
		resData.error = "Invalid request format."
		return false
	else
		requestData.request = request
		requestedAction = request.action
	end
	
	if requestedAction ~= nil then
		func, err = loadfile("/userData/actions/" .. requestedAction .. ".lua")
	end
	
	if func ~= nil then
		resData.returnValue = func(env, shared, requestData)
		resData.success = "true"
	else
		warn("Recieved unknown user action request: " .. tostring(requestedAction))
		resData.success = "false"
		resData.error = "Invalid user action"
	end
end

do 
	local suc, err = xpcall(executeUserOrder, debug.traceback)
	if suc ~= true then
		debug.err(suc, err)
		resData.success = "false"
		resData.error = "User script crash"
		resData.scriptError = tostring(err)
	end
end


do --debug
	if type(shared.requestCount) ~= "number" then
		shared.requestCount = 0
	end
	shared.requestCount = shared.requestCount +1
	resData.requestID = tostring(shared.requestCount)
end


callbackStream:push({headers = resHeaders, data = resData})
ldlog("CALLBACK THREAD END")
env.stop()