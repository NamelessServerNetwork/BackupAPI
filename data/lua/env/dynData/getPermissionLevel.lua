return function(user, perm)
	local userID = env.getUserID(user)
	local db = env.userDB
	local reason, suc = nil, nil
	local permLevel
	
	suc = db:exec([[SELECT level FROM permissions WHERE userID = "]] .. tostring(userID) .. [[" AND permission = "]] .. perm .. [["]], function(udata, cols, values, names)
		permLevel = values[1]
		return 0
	end)
	
	if suc == 0 and permLevel ~= nil then
		return true, permLevel
	elseif suc == 0 and permLevel == nil then
		return false, permLevel
	else
		return suc, reason
	end
end