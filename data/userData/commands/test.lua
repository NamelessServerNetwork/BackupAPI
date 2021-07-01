local env, args = ...

local function checkPassword(userID, loginPassword)
	local db = env.userDB
	local userExists = false
	local suc, reason = nil, nil
	local username, userPassword = nil, nil
	
	
	if type(tonumber(userID)) ~= "number" then
		return false, -201, "No valid userID given"
	end
	if type(loginPassword) ~= "string" or loginPassword == "" then
		return false, -2, "No valid password given"
	end
	
	dlog("Try to login with userID: \"" .. userID .. "\"")
	
	--check user existance.
	db:exec([[SELECT username, password FROM users WHERE id = "]] .. userID .. [["]], function(udata, cols, values, names)
		username = values[1]
		userPassword = values[2]
		
		if not userExists then
			userExists = true
		elseif userExists then
			err("Multiple users with same userID are existing: " .. username .. "; userID: " .. tostring(userID))
			suc = -301
			reason = "Multiple user with same userID are existing."
		end
		return 0
	end)
	
	if suc ~= 0 and suc ~= nil then
		return false, suc, reason
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

local function getUserIDByName(username)
	local db = env.userDB
	local userExists = false
	local suc, reason = nil, nil
	local userID = nil
	
	if type(username) ~= "string" or username == "" then
		return false, -1, "No valid username given"
	end
	
	dlog("Try to get user by name: \"" .. username .. "\"")
	
	--check user existance.
	db:exec([[SELECT id FROM users WHERE username = "]] .. username .. [["]], function(udata, cols, values, names)
		userID = tonumber(values[1])
		
		if not userExists then
			userExists = true
		elseif userExists then
			err("Multiple users with same username are existing: " .. username)
			suc = -302
			reason = "Multiple user with same username are existing."
		end
		return 0
	end)
	
	if suc ~= 0 and suc ~= nil then --if something went wrong
		return false, suc, reason
	elseif type(userID) == "number" then --if anything is fine
		return true, userID
	end
	return false, -4, "username not found" --if the username can not be found
end

--print(getUserIDByName(args[1]))
--print(login(args[1], args[2]))