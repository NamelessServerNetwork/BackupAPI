return function(username, password) --ToDo: add database lookup
	if password == "123" then
		return true
	else
		return false, "Wrong password"
	end
end