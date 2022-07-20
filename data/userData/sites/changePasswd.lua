local requestData = ...

local body = env.dyn.html.Body.new()

body:addHeader(3, "Change password")
body:addP("Here you can change your password.")
body:addP("Tip: do never use the same passwoed for multiple services.")

body:addAction("", "POST", {
    {"input", name = "Username:", target = "username", value = "testuser"},
    {"input", name = "Current password:", target = "currentPasswd", value = "cp"},
    {"input", name = "New password:", target = "newPasswd1", value = "np1"},
    {"input", name = "Repeate password:", target = "newPasswd2", value = "np2"},
    {"hidden", target = "action", value = "changePasswd"},
    {"submit", value = "Change password"},
})

return body:generateCode()