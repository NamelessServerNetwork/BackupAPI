--LÖVE main file 
local version = "v0.0.1"

function love.load(args)
	loadfile("lua/init/init.lua")(version, args)
end