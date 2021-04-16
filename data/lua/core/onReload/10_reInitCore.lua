local env, shared = ...

if env.devConf.onReload.core then
	dlog("Re init core")

	_G.loadfile = env.org.loadfile

	local _, newEnv, newShared = loadfile("data/lua/core/init/init.lua")(env.version, env.args)
	
	env.dl.setEnv(newEnv, newShared)
end