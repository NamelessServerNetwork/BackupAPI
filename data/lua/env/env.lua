--default env for all threads.

local orgRequire = require
local function require(p)
	debug.setFuncPrefix("[REQUIRE]")
	ldlog(tostring(p))
	return orgRequire(p)
end

local orgLoadfile = loadfile
local function loadfile(p)
	debug.setFuncPrefix("[LOADFILE]")
	ldlog(tostring(p))
	return orgLoadfile("data/" .. p)
end

_G.require = require
_G.loadfile = loadfile