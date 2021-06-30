local env, shared, args = ...

local suc, reason = env.checkUserLogin(args.username, args.password)

if suc then
	local loginToken = env.newSession({username = args.username})
	
	return {success = true, loginToken = loginToken}
else
	return {success = false, reason = reason}
end