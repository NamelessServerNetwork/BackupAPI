local run = true --debug
if not run then return true end
run = nil


log("Initialize HTTP server")

local http_server = require("http.server")

local port = 8023 -- 0 means pick one at random

env.httpCQ = {lastID = 0}

--env.httpCQ = env.cqueues.new()

local function getFunc(path)
	local suc, err = loadfile(path)
	local func
	
	if suc == nil then
		err(suc, err)
		return nil
	end
	func = suc(env, shared)
	if type(func) ~= "function" then
		err(func)
		return nil
	end
	return func
end

dlog("Create server object")
local myserver = http_server.listen({
	--cq = env.httpCQ;
	host = "0.0.0.0";
	port = port;
	onstream = getFunc("lua/threads/httpServer/serverCallback.lua");
	onerror = function(myserver, context, op, err, errno) -- luacheck: ignore 212
		local msg = op .. " on " .. tostring(context) .. " failed"
		if err then
			msg = msg .. ": " .. tostring(err)
		end
		debug.err("HTTP SERVER ERROR:")
		debug.err(msg, "\n")
	end;
})

dlog("Set server to listen")
myserver:listen()

if env.isDevMode() then
	dlog("Set event listeners")
	env.event.listen("reloadHttpServerCallback", function() 
		log("Relaod HTTP server callback")
		local newCallback = getFunc("lua/threads/httpServer/serverCallback.lua");
		if newCallback == nil then
			err("Cant load new HTTP server callback")
		else
			myserver.onstream = newCallback
			log("Sucsesfully reloaded HTTP server callback")
		end
	end)
end

do
	local bound_port = select(3, myserver:localname())
	log("Now listening on port " .. tostring(bound_port))
end

log("HTTP server initialization done")

local count = 0
local function update()
	local stopAtHighCount = false --debug
	if count > 3000 and stopAtHighCount then 
		fatal("too many counts")
	else
		assert(myserver:step(1))
	end
	
	count = count +1
	
	--print("T", os.time(), count)
end
