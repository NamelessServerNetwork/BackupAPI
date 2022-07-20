local requestData = ...

local body = env.dyn.html.Body.new()
local id = tostring(env.getThreadInfos().id)

local suc, output = execScript("changePasswd.exp " .. id, {
    ["DAMS_USER_" .. id] = requestData.request.username,
    ["DAMS_PASSWD_" .. id] = requestData.request.currentPasswd,
    ["DAMS_NEWPASSWD1_" .. id] = requestData.request.newPasswd1,
    ["DAMS_NEWPASSWD2_" .. id] = requestData.request.newPasswd2,
}, false)


if suc == 0 then
    body:addP("Password successfully changed!")
else 
    body:addP("Password not changed")
end

body:goBack(requestData, 3)

return body:generateCode()