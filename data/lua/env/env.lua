--default env for all threads.

local orgRequire = require
local function require(p)
	debug.setFuncPrefix("[REQUIRE]")
	dlog(tostring(p))
	return orgRequire(p)
end

local orgLoadfile = loadfile
local function loadfile(p)
	debug.setFuncPrefix("[LOADFILE]")
	dlog(tostring(p))
	return orgLoadfile("data/" .. p)
end

_G.require = require
_G.loadfile = loadfile