return function()
	getmetatable(env)._internal.threadIsActive = false
end