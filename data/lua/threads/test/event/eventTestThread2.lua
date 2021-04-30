log("--===== Event test thread #2 start =====--")

local count = 0

local function update()
	sleep(1)
	
	env.event.push("TEST", {td = count})
	count = count +1
end