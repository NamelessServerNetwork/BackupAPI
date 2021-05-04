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
		resData.value = func()
	else
		warn("Recieved unknown user action request: " .. tostring(headers.action))
	end
end

do 
	local suc, err = xpcall(executeUserOrder, debug.traceback)
	if suc ~= true then
		debug.err(suc, err)
		resHeaders.success = "false"
	else
		resHeaders.success = "true"
	end
end

callbackStream:push({headers = resHeaders, data = resData})
ldlog("CALLBACK THREAD END")
env.stop()