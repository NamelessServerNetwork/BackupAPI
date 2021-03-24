local env, args = ...
local lua = {}
local luaShell = loadfile("lua/libs/thirdParty/luaShell.lua")(env)

function lua.update(input, command, args)
	debug.setFuncPrefix("[LUA]", true, true)
	
	luaShell.textInput(input)
end

env.terminal.setTerminal(lua, "[LUA]")