--DAMS main file
local global = ...

function love.update()
	local input = tostring(io.read())
	log("> " .. tostring(input))
	
	if input == "exit" then
		love.quit()
	elseif global.devConf.devMode then
		--log(": " .. tostring(loadstring(input)))
	end
end

