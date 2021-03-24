--DAMS main file
local env, shared = ...

terminal = {
	currentTerminal = nil,
	currentTerminalPrefix = "",
}

function terminal.setTerminal(t, prefix)
	terminal.currentTerminal = t
	terminal.currentTerminalPrefix = prefix
end

function love.update()
	local command, args = "", {}
	local callMainTerminal = false
	local input = tostring(io.read())
	
	for c in string.gmatch(input, "[^ ]+") do
		if command == "" then
			if c == env.devConf.terminalCommands.forceMainTerminal then
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
		debug.setFuncPrefix("[TERMINAL]", true, true)
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

env.terminal = terminal