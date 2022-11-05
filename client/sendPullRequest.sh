#!/bin/lua
package.path = "libs/?.lua;" .. package.path
local version = "v0.1d"

--===== conf =====--
local conf = {
    --uri = "https://damsdev.namelessserver.net", --backup servers uri
    uri = "http://localhost:8023",
    backup = "test", --rsnapshot instance
    token = "WZcTDbHLceaOp9BL$Ildna7y8mguaa1X9Cpe2QEliXvOdB2Of",
}

--===== local funcs ======--
local function error(...)
    io.stderr:write(...)
    io.stderr:flush()
end

--===== prog start =====--
local damsClient = require("DamsClient").new({uri = conf.uri})
local ut = require("UT")

print("requesting backup pull (" .. conf.backup .. ") from: " .. conf.uri)

local suc, headers, response = damsClient:request({
    action = "pullBackup",
    backup = conf.backup,
    token = conf.token,
})

if not suc then
    error("ERROR: could not request a backup pull. generating full response dump:\nHEADERS: \n" .. ut.tostring(headers) .. "\nRESPONSE:\n" .. ut.tostring(response))
    os.exit(1)
elseif not response.success then
    error("ERROR: backup API returned an error\ncode: " .. tostring(response.error.code) .. "\nmsg: " .. tostring(response.error.msg) .. "\n")
    os.exit(1)
else
    print("backup pull requested.")
    os.exit(0)
end
