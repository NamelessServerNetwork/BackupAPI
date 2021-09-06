local env, args = ...


env.commands.rlenv(env, {}, {})



--print(cts({pfunc(function(a, b) return a+b end, 1, 2)()}))


local user, reason = env.dyn.User.new(1)
print(env.lib.ut.tostring(user), reason)


--print(env.dyn.User.checkPassword({id=1}, "123"))



--print(getUserIDByName(args[1]))
--print(login(args[1], args[2]))