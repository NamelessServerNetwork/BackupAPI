--default env for all threads.
local env, mainThread = ...

env.org = {
	require = require,
	loadfile = loadfile,
	print = print,
	io = {
		write = io.write,
		flush = io.flush,
	},
}

env.debug.internal.ioWriteBuffer = ""

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

if not mainThread then
	local thread = orgRequire("love.thread")
	local debug_print = thread.getChannel("debug_print")
	
	_G.print = function(...)
		for _, msg in pairs({...}) do
			debug_print:push(msg)
		end
	end
	
	_G.io.write = function(...)
		for _, msg in pairs({...}) do
			env.debug.internal.ioWriteBuffer = env.debug.internal.ioWriteBuffer .. tostring(msg)
		end
	end
	
	_G.io.flush = function()
		print(env.debug.internal.ioWriteBuffer)
		env.debug.internal.ioWriteBuffer = ""
	end
end