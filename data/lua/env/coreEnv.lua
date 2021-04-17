--default env for all threads.
local env = ...

env.org = {
	require = require,
	loadfile = loadfile,
	print = print,
	io = {
		write = io.write,
		flush = io.flush,
	},
}

local orgRequire = require
local orgLoadfile = loadfile

env.debug.internal.ioWriteBuffer = ""

if not env.mainThread then
	local thread = orgRequire("love.thread")
	local debug_print = thread.getChannel("debug_print")
	
	_G.print = function(...)
		local msgs = ""
		for _, msg in pairs({...}) do
			msgs = msgs .. tostring(msg) .. "\t"
		end
		debug_print:push(msgs)
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

local function require(p)
	debug.setFuncPrefix("[REQUIRE]")
	ldlog(tostring(p))
	return orgRequire(p)
end

local function loadfile(p)
	local func, err
	debug.setFuncPrefix("[LOADFILE]")
	ldlog(tostring(p))
	func, err = orgLoadfile("data/" .. p)
	if func == nil then
		debug.err(func, err)
	end
	return func, err
end

_G.require = require
_G.loadfile = loadfile