local body = env.dyn.html.Body.new()

body:addHeader(3, "Login")
body:addAction("", "POST", {
    {"hidden", target = "action", value = "login"},
    {}
})

return body:generateCode()