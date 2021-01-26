local thread, channel 

function love.load()
	print("LOAD")
	
	channel = love.thread.newChannel()
	
	thread = love.thread.newThread("thread.lua")
	thread:start(channel)
end

function love.update(dt)
	local msg = io.read("*line")
	
	channel:push({test = "t1", test2 = "t2"})
	
	if msg ~= nil then
		--print(msg)
	end
end

function love.threaderror(thread, err)
	print(err)
end

function love.quit()
	print("QUIT")
end