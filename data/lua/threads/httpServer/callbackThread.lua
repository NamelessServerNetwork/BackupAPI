ldlog("CALLBACK THREAD START")

local callbackStream = env.thread.getChannel("HTTP_CALLBACK_STREAM#" .. tostring(env.getThreadInfos().id))

local resHeaders = {}
local resData = {success = false}
local resDataString = "If you see this, something went terrebly wrong. Please contact a system administrator."

local requestData = env.initData.args

local requestFormatter, responseFormatter
local requestFormatterName, responseFormatterName
local requestFormatterPath, responseFormatterPath = "./userData/requestFormatters/", "./userData/responseFormatters/"

local canExecuteUserOrder = true
	
local _, userRequestTable

local function executeUserOrder(request)
	local func, err, requestedAction

	if type(request) ~= "table" then
		warn("Recieved invalid request: " .. request)
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
		local logPrefix = env.debug.getLogPrefix()
		env.debug.setLogPrefix("[USER_ACTION]")
		resData.returnValue = func(env, shared, requestData)
		resData.success = true
		env.debug.setLogPrefix(logPrefix)
	else
		warn("Recieved unknown user action request: " .. tostring(requestedAction))
		resData.error = "Invalid user action"
	end
end

local function loadFormatter(headerName, path)
	ldlog("Load " .. headerName .. " formatter, dir: " .. path)

	local formatter, suc, err

	if requestData.headers[headerName] ~= nil then
		local requestedFormatter = requestData.headers[headerName].value
		local pathString = path .. "/" .. requestedFormatter .. ".lua"
		local loveFSCompatiblePathString = string.sub(pathString, 3)--yes it is actually necessary to remove the './' infromt of the path...

		formatter, err = loadfile(pathString)

		if type(formatter) ~= "function" then
			if env.lib.fs.getInfo(loveFSCompatiblePathString) == nil then --only generates a easyer to understand error msg if the formatter is not existing.
				resData.error = "Invalid " .. headerName .. ": " .. requestedFormatter
				canExecuteUserOrder = false
				return 1, headerName .. " not found"
			end

			warn("Can't load requestet " .. headerName .. ": ".. requestedFormatter .. ", error: " .. err)
			resData.error = "Can't load requestet " .. headerName
			resData.scriptError = err
			canExecuteUserOrder = false
			return 2, err
		else
			return formatter, requestedFormatter
		end
	end
end
	
do --formatting user request
	local suc, userRequest
	local logPrefix

	requestFormatter, requestFormatterName, errorCode = loadFormatter("request-format", requestFormatterPath)
	if requestFormatter == 1 then
		resData.errorCode = -1001
	elseif requestFormatter == 2 then
		resData.errorCode = -1011
	end

	responseFormatter, responseFormatterName = loadFormatter("response-format", responseFormatterPath)
	if responseFormatter == 1 then
		resData.errorCode = -1002
	elseif responseFormatter == 2 then
		resData.errorCode = -1012
	end

	if canExecuteUserOrder then
		logPrefix = debug.getLogPrefix()
		debug.setLogPrefix("[REQUEST_FORMATTER][" .. requestFormatterName .. "]")
		suc, userRequest = requestFormatter(requestData.body)
		debug.setLogPrefix(logPrefix)

		userRequestTable = userRequest

		if suc ~= true then
			warn("Failed to execute request formatter: " .. requestFormatterName .. "; " .. tostring(userRequest))
			resData.error = "Request formatter returned an error."
			resData.scriptError = tostring(userRequest)
			canExecuteUserOrder = false
		end
	end
end

if canExecuteUserOrder then
	local suc, err = xpcall(executeUserOrder, debug.traceback, userRequestTable)
	if suc ~= true then
		debug.err(suc, err)
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

do --formatting response table
	--resData = env.lib.serialization.dump(resData) --placeholder
	local suc, responseString = false, "[Formatter returned no error value]"

	if type(responseFormatter) == "function" then
		suc, responseString = responseFormatter(resData)
	end

	if suc ~= true then
		local newResponseString = [[
Can't format response table. 
Formatter error: ]] .. tostring(responseString) .. [[ 
Falling back to human readable lua-table.
		]] .. "\n"

		newResponseString = newResponseString .. env.lib.ut.tostring(resData)
		resDataString = newResponseString
	else
		resDataString = responseString
	end
end

callbackStream:push({headers = resHeaders, data = resDataString})
ldlog("CALLBACK THREAD END")
env.stop()