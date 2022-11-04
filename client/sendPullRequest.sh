#!/bin/lua
package.path = "libs/?.lua;" .. package.path
local version = "v0.1"

--===== conf =====--
local conf = {
    uri = "https://damsdev.namelessserver.net", --backup servers uri
    backup = "test", --rsnapshot instance
}

--===== prog start =====--
local damsClient = require("DamsClient").new({uri = conf.uri})
local ut = require("UT")

print("requesting backup pull (" .. conf.backup .. ") from: " .. conf.uri)

local headers, response = damsClient:request({
    action = "pullBackup",
    backup = conf.backup,
})

if not response.success then
    io.stderr:write("could not request backup pull")
    io.stderr:write("full response dump: \n" .. ut.tostring(response))
    io.stderr:flush()
    os.exit(1)
else
    print("done")
    print("rsnapshot log: \n" .. response.returnValue.log)
end