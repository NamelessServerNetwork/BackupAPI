env.getThreadID = function()
	return getmetatable(env)._internal.threadID
end