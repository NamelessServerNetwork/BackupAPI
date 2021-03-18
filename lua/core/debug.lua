local devMode, defaultPrefix = ...

local orgDebug = _G.debug
local debug = {
	global = {},
	
	internal = {
		logPrefix = "",
		debugPrefix = "",
		functionPrefixes = {},
	},
	
	debug = orgDebug,
	orgDebug = orgDebug,
}

--===== set basic log functions =====--
local function getDebugPrefix()
	return debug.internal.debugPrefix
end
local function setDebugPrefix(prefix)
	debug.internal.debugPrefix = tostring(prefix)
end

local function getFuncPrefix(stackLevel, fullPrefixStack)
	local prefix, exclusive = "", false
	local prefixTable
	if fullPrefixStack == nil then fullPrefixStack = true end
	
	if stackLevel == nil or type(stackLevel) == "number" then
		prefix, exclusive, fullStack = getFuncPrefix(orgDebug.getinfo(stackLevel or 2).func)
	elseif type(stackLevel) == "function" then
		local prefixTable = debug.internal.functionPrefixes[stackLevel]
		if prefixTable == nil then
			return "", false
		else
			return tostring(prefixTable.prefix), prefixTable.exclusive, prefixTable.fullStack
		end	
	end
	
	if fullPrefixStack and fullStack or fullStack == nil then
		for stackLevel = stackLevel +1, math.huge do
			local stackInfo = orgDebug.getinfo(stackLevel)
			local stackPrefix = ""
			local stackExclusive, fullStack
		
			if stackInfo == nil then break end
		
			stackPrefix, stackExclusive, fullStack = getFuncPrefix(stackInfo.func)
			
			if stackExclusive then
				exclusive = true
			end
			
			prefix = stackPrefix .. prefix
			
			if fullStack == false then
				break
			end
		end
	end
	
	return tostring(prefix), exclusive
end
local function setFuncPrefix(prefix, exclusive, noFullStack, stackLevel) 
	local prefixTable = {}
	local func
	
	if stackLevel == nil or type(stackLevel) == "number" then
		func = orgDebug.getinfo(stackLevel or 2).func
	elseif type(stackLevel) == "function" then
		func = stackLevel
	end
	
	if prefix ~= nil then
		prefixTable.prefix = prefix
		prefixTable.exclusive = exclusive
		if noFullStack == false or noFullStack == nil then
			prefixTable.fullStack = true
		else
			prefixTable.fullStack = false
		end
		debug.internal.functionPrefixes[func] = prefixTable
	else
		debug.internal.functionPrefixes[func] = nil
	end
end

local function getLogPrefix()
	return tostring(debug.internal.logPrefix)
end
local function setLogPrefix(prefix, keepPrevious)
	if keepPrevious then
		debug.internal.logPrefix = getLogPrefix() .. prefix
	else
		debug.internal.logPrefix = prefix
	end
end

local function log(...)
	local msgs = ""
	--local funcPrefix, exclusiveFuncPrefix = getFuncPrefix(orgDebug.getinfo(2).func)
	local funcPrefix, exclusiveFuncPrefix = getFuncPrefix(3)
	
	if exclusiveFuncPrefix then
		msgs = funcPrefix .. msgs
	else
		msgs = getLogPrefix() .. funcPrefix .. msgs
	end	
	msgs = msgs .. ": "
	for _, msg in pairs({...}) do
		msgs = msgs .. tostring(msg) .. "     "
	end
	
	print("[" .. os.date("%X") .. "]" .. getDebugPrefix() .. msgs)
	setDebugPrefix("")
end

local dlog
if devMode then
	dlog = function(...)
		setDebugPrefix("[DEBUG]")
		log(...)
	end
else
	dlog = function() end
end

--===== debug function =====--
setLogPrefix(defaultPrefix)
dlog("set debug functions")

debug.log = log
debug.dlog = dlog

debug.setLogPrefix = setLogPrefix
debug.getLogPrefix = getLogPrefix

debug.setFuncPrefix = setFuncPrefix
debug.getFuncPrefix = getFuncPrefix

debug.setDebugPrefix = setDebugPrefix
debug.getDebugPrefix = getDebugPrefix

--===== debug functions =====--
dlog("set global debug functions")

debug.global.log = log
debug.global.dlog = dlog

--===== initialize =====--
dlog("initialize debug environment")

--=== set global metatables ===--
dlog("set global debug metatables")

_G.debug = setmetatable(debug, {__index = function(t, i)
	if orgDebug[i] ~= nil then
		return orgDebug[i]
	else
		return nil
	end
end})

_G = setmetatable(_G, {__index = function(t, i)
	return debug.global[i]
end})

return debug