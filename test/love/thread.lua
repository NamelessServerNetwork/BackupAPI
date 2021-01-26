local channel = ...
local timer = require("love.timer")

print(channel)

while true do
	local msg = channel:pop()
	
	if msg ~= nil then
		print(msg.test)
	end
end