local Session = {}

function Session.new(token)
    local self = setmetatable({}, {__index = Session})
    
    local sessionExists = false

    self.sessionData = {}
    self.sessionData.token = token

    errCode = env.loginDB:exec([[SELECT userID, expireTime FROM sessions WHERE token = "]] .. token .. [["]], function(_, cols, values, names)
        for index, name in ipairs(names) do
            self.sessionData[name] = values[index]
        end
		return 0
	end)

    if errCode ~= 0 then
        return false, errCode
    end

    if not self.sessionData.userID then
        return false, -10, "Token not found"
    end

    if tonumber(self.sessionData.expireTime) ~= -1 and tonumber(self.sessionData.expireTime) < os.time() then
        if env.devConf.session.deleteExpiredSessions then
            self:delete()
        end

        return false, -11, "Token expired"
    end

    return self
end

function Session.create(user, expireTime) --expireTime in seconds ongoing from 1970 00:00:00 UTC (os.time(...) in unix systems) or a time table.
    local token = env.lib.ut.randomString(32)
    local suc

    if type(expireTime) == "table" then
        expireTime = os.time(expireTime)
    end

    suc = env.loginDB:exec([[INSERT INTO sessions VALUES (]] .. tostring(user:getID()) .. [[, "]] .. token .. [[", ]] .. expireTime ..[[)]])

    if suc ~= 0 then
        return false, suc
    else
        return true, Session.new(token)
    end
end


function Session:getToken()
    return self.sessionData.token
end

function Session:renew(expireTime)
    local suc

    if type(expireTime) == "table" then
        expireTime = os.time(expireTime)
    end

    if type(expireTime) ~= "number" then
        error("Invalid expire time given", 2)
    end

    suc = env.loginDB:exec([[UPDATE sessions SET expireTime = ]] .. tostring(expireTime) .. [[ WHERE token = "]] .. self:getToken() .. [["]])

    if suc == 0 then
        return true
    else
        return false, suc
    end
end

function Session:delete()
    local suc

    suc = env.loginDB:exec([[DELETE FROM sessions WHERE token = "]] .. self:getToken() .. [["]])

    if suc == 0 then
        return true
    else
        return false, suc
    end
end


return Session