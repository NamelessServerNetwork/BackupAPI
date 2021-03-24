--LÖVE main file 
local version = "v0.0.4"

function love.load(args)
	print("--===== Starting DAMS " .. tostring(version) .. " =====--")
	
	loadfile("data/lua/init/init.lua")(version, args)
end