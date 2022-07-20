local requestData = ...

local body = env.dyn.html.Body.new()

body:addHeader(2, "DAMS dev main page")

body:addRefButton("test", "/test")
body:addP("")
body:addRefButton("CMS test 1", "/cmsTest")
body:addP("")
body:addRefButton("Change Password", "/changePasswd")
body:addP("")
body:addAction("TEST", "POST", {{"submit", name = "dumpRequest"}, {"hidden", name="action", value="dumpRequest"}})

return body:generateCode()