local global = ...

local orgDebug = _G.debug
local debug = {
	global = {},
	
	internal = {
		logPrefix = "",
		functionPrefixes = {},
	},
	
	debug = orgDebug,
	orgDebug = orgDebug,
}

--===== set basic log functions =====--
local function getFuncPrefix(func)
	local prefix = debug.internal.functionPrefixes[func]
	if prefix == nil then
		return "", false
	end	
	return tostring(prefix.prefix), prefix.exclusive
end
local function setFuncPrefix(prefix, exclusive, func)
	local prefixTable = {}
	
	if func == nil then	
		func = orgDebug.getinfo(2).func
	end
	
	prefixTable.prefix = prefix
	prefixTable.exclusive = exclusive
	debug.internal.functionPrefixes[func] = prefixTable
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
	local funcPrefix, exclusiveFuncPrefix = getFuncPrefix(orgDebug.getinfo(2).func)
	
	if exclusiveFuncPrefix then
		msgs = funcPrefix .. msgs
	else
		msgs = getLogPrefix() .. funcPrefix .. msgs
	end	
	msgs = msgs .. ": "
	for _, msg in pairs({...}) do
		msgs = msgs .. tostring(msg) .. "     "
	end
	
	print("[" .. os.date("%X") .. "]" .. msgs)
end

local dlog
if global.devConf.devMode then
	dlog = function(...)
		local funcPrefix, exclusiveFuncPrefix = getFuncPrefix(orgDebug.getinfo(2).func)
		local prefix = "[DEBUG]"
		
		if not exclusiveFuncPrefix then
			prefix = prefix .. getLogPrefix()
		end
		setFuncPrefix(prefix .. funcPrefix, true)
		
		log(...)
	end
else
	dlog = function() end
end

--===== debug function =====--
dlog("set debug functions")
debug.log = log
debug.dlog = dlog

debug.setLogPrefix = setLogPrefix
debug.setFuncPrefix = setFuncPrefix

--===== debug functions =====--
dlog("set global debug functions")

debug.global.log = log
debug.global.dlog = dlog

--===== initialize =====--
dlog("initialize debug environment")

--=== set global metatables ===--
dlog("set global debug metatables")

_G.debug = setmetatable({}, {__index = function(t, i)
	if debug[i] ~= nil then
		return debug[i]
	elseif orgDebug[i] ~= nil then
		return orgDebug[i]
	else
		return nil
	end
end})

_G = setmetatable(_G, {__index = function(t, i)
	return debug.global[i]
end})

return debug