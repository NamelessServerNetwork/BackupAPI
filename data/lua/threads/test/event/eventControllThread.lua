log("--===== Event controll thread start =====--")

local test1 = function(data) 
	print("TEST: " .. env.ut.tostring(data)) 
end

env.event.listen("TEST", test1)