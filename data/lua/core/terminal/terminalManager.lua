--DAMS main file
local env, shared = ...

local getch = require("getch")

local terminal = {
	input = "",
	currentTerminal = nil,
	currentTerminalPrefix = "",
	
	terminal = loadfile(env.devConf.terminalPath .. "terminal.lua")(env),
}

function terminal.setTerminal(t, prefix)
	terminal.currentTerminal = t
	terminal.currentTerminalPrefix = prefix
end

function terminal.input(input) 
	local command, args = "", {}
	local callMainTerminal = false
	
	for c in string.gmatch(input, "[^ ]+") do
		if command == "" then
			if c == env.devConf.terminal.commands.forceMainTerminal then
				callMainTerminal = true
			else
				command = c
			end
		else	
			table.insert(args, c)
		end
	end
	
	if terminal.currentTerminal ~= nil and not callMainTerminal then
		debug.setFuncPrefix(terminal.currentTerminalPrefix, true, true)
	else
		debug.setFuncPrefix("[MAIN_TERMINAL]", true, true)
	end
	
	plog("> " .. tostring(input))
	
	if terminal.currentTerminal ~= nil and not callMainTerminal then
		terminal.currentTerminal.update(input, command, args)
	elseif env.commands[command] ~= nil then
		local suc, err = xpcall(env.commands[command], debug.traceback, env, args)
		
		plog(suc, err)
	else
		plog("Command \"" .. command .. "\" not found")
	end
end

function terminal.autoComp(t)
	print(t)
end

function love.update()
	--local input = tostring(io.read())
	--local input = getch.blocking()
	terminal.terminal.update()
	terminal.terminal.draw()
end

env.terminal = terminal