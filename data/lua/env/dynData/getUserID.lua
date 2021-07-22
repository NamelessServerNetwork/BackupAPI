return function(user)
	if type(user) == "number" then
		return user
	else
		return user:getID()
	end
end