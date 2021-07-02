return function(self, loginPassword)
	local db = env.userDB
	local userExists = false
	local errCode, reason = nil, nil
	local username, userPassword = nil, nil
	local userID = self.id
	
	if type(tonumber(userID)) ~= "number" then
		return false, -201, "No valid userID given"
	end
	if type(loginPassword) ~= "string" or loginPassword == "" then
		return false, -2, "No valid password given"
	end
	
	dlog("Try to login with userID: \"" .. userID .. "\"")
	
	--check user existance.
	errCode = db:exec([[SELECT username, password FROM users WHERE id = "]] .. tostring(userID) .. [["]], function(udata, cols, values, names)
		username = values[1]
		userPassword = values[2]
		
		if not userExists then
			userExists = true
		elseif userExists then
			err("Multiple users with same userID are existing: " .. username .. "; userID: " .. tostring(userID))
			errCode = -301
			reason = "Multiple user with same userID are existing."
		end
		return 0
	end)
	
	if errCode ~= 0 and errCode ~= nil then
		return false, errCode, reason
	else
		if userExists then
			if userPassword == loginPassword then
				return true
			else
				return false, -3, "No password not matching."
			end
		else
			return false, -202, "User not found by userID"
		end
	end
end