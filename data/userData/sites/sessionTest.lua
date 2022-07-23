log(Session)

--debug.setLogPrefix("TTTT")

local user = env.User.new(1)
local session, err

local timeTable = os.date("*t")
timeTable.sec = timeTable.sec + 120

if true then
    _, session, token = Session.create(user, timeTable)
    log("session:", session)
    log("sessionID:", session:getSessionID())
    log("token:", token)
end

log(Session.new("HjG9GGR2jI3grIJWq4eomnPMV6xZ5QDb", "WmxzuVDnB9mhRT8RnLhxsa2j6l7OJAgR"))

timeTable = os.date("*t")
timeTable.min = timeTable.min + 5
--print("RENEW:", session:renew(timeTable))

--print("DEL:", session:delete())