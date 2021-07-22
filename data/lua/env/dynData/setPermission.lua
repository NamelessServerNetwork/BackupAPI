return function(user, perm, level)
	local userID = env.getUserID(user)
	local db = env.userDB
	local reason, suc = nil, nil
	
	local permSetAlready, permLevelError = env.getPermissionLevel(user, perm)
	
	if permSetAlready then
		dlog("Update permission: " .. perm .. ", userID: " .. tostring(userID) .. ", to level: " .. tostring(level))
		suc = db:exec([[UPDATE permissions SET level = "]] .. tostring(level) .. [[" WHERE permission = "]] .. perm .. [[" AND userID = ]] .. tostring(userID))
	elseif permSetAlready == false then
		dlog("Set permission: " .. perm .. ", userID: " .. tostring(userID) .. ", to level: " .. tostring(level))
		suc = db:exec([[INSERT INTO permissions VALUES ("]] .. tostring(userID) .. [[", "]] .. perm .. [[", ]] .. tostring(level) .. [[)]])
	else
		err("Cant set permission: " .. tostring(permSetAlready) .. " (" .. permLevelError .. ")")
		suc, reason = -11, permLevelError
	end
	
	return suc, reason
end