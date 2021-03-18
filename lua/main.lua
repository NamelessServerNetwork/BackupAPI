--LÖVE main file 
local version = "v0.0.3"

function love.load(args)
	loadfile("lua/init/init.lua")(version, args)
end