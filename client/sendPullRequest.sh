#!/bin/lua
package.path = "libs/?.lua;" .. package.path
local version = "v0.2"

local args = {...}

--===== conf =====--
local conf = {
    name = "TEST_BACKUP_CLIENT",
    uri = "http://localhost:8023",
    backup = "test", --rsnapshot instance
    token = "WZcTDbHLceaOp9BL$Ildna7y8mguaa1X9Cpe2QEliXvOdB2Of",

    mail = {
        sender = "no-reply@namelessserver.net",
        receiver = "test@namelessys.de",
    }
}

--===== local funcs ======--
local function mail(subject, text)
    if type(conf.mail.sender) ~= "string" or type(conf.mail.receiver) ~= "string" then
        return false
    end
    print("echo '" .. text .. "' | mail -r " .. conf.mail.sender .. " -s '" .. subject .. "' " .. conf.mail.receiver)
    os.execute("echo '" .. text .. "' | mail -r " .. conf.mail.sender .. " -s '" .. subject .. "' " .. conf.mail.receiver)
end

local function error(...)
    io.stderr:write(...)
    io.stderr:flush()
    mail("[" .. conf.name .. "]: Cant pull backup: " .. conf.backup, table.concat({...}))
end

--===== prog start =====--
local damsClient = require("DamsClient").new({uri = conf.uri})
local ut = require("UT")

if args[1] == "error" or args[1] == "-e" then
    error("test error\n")
    os.exit(0)
end

print("requesting backup pull (" .. conf.backup .. ") from: " .. conf.uri)

local suc, headers, response = damsClient:request({
    action = "pullBackup",
    backup = conf.backup,
    token = conf.token,
})

if not suc then
    error("ERROR: could not request a backup pull. generating full response dump:\nHEADERS: " .. ut.tostring(headers) .. "\nRESPONSE: " .. ut.tostring(response))
    os.exit(1)
elseif not response.success then
    error("ERROR: backup API returned an error\ncode: " .. tostring(response.error.code) .. "\nmsg: " .. tostring(response.error.msg) .. "\n")
    os.exit(1)
else
    print("backup pull requested.")
    os.exit(0)
end
