return function(udata)
	debug.setFuncPrefix("[USER]")
	
	local self = setmetatable({}, {__index = env.dyn.User})
	
	if type(udata) == "number" then --if data is the userID.
		udata, code, msg = self.getData({id = udata})
		if udata == false then
			return udata, code, msg
		end
	elseif type(udata) ~= "table" then --if data is neither data table or userID.
		return false, "No valid data given"
	end
	
	self.id = udata.id
	self.username = udata.username
	
	self.loginToken = udata.loginToken
	
	return self
end