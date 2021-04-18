log("--===== SHARED TEST THREAD#2 START ======--")

--[[
local channel = env.thread.getChannel("test1")

while true do
	
	while channel:peek() ~= nil do
		local v = channel:pop()
		dlog(env.ut.tostring(v))
		
		if type(v) == "table" then
			dlog(env.ut.tostring(getmetatable(v)))
		end
	end
	
	sleep(1)
end
]]

sleep(1)

log(shared.testVal1)



log("--===== SHARED TEST THREAD#2 END ======--")