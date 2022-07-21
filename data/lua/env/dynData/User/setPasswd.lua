return function(self, passwd)
	local userID = self:getID()
	local db = env.loginDB
	local reason, suc = nil, nil
	
	debug.ulog("Set passwd: userID: " .. tostring(userID))
	suc = db:exec([[UPDATE users SET password = "]] .. env.hashPasswd(passwd) .. [[" WHERE id = ]] .. tostring(userID))
	
	return suc, reason
end