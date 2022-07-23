log(session)

local user = env.User.new(1)
local session, err

local timeTable = os.date("*t")
timeTable.sec = timeTable.sec + 2

if true then
    _, session = Session.create(user, timeTable)
    log(session)
    log(session:getToken())
end

--log(Session.new("6bVkUe4gVYRp0Ts4xhWBlI2On9YBhZN4"))

timeTable = os.date("*t")
timeTable.min = timeTable.min + 5
--print("RENEW:", session:renew(timeTable))

--print("DEL:", session:delete())