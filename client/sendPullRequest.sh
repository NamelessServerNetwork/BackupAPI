#!/bin/lua
package.path = "libs/?.lua;" .. package.path
local version = "v1.0"

local args = {...}

--===== default conf =====--
local conf = {
    name = "TEST_BACKUP_CLIENT", --client name
    uri = "http://localhost:8023", --backup server uri
    backup = "test", --rsnapshot instance
    token = "8vL4lzs8JrKOjYrO$L6mkFrgWqbrcKeItiEEGpxXeTc3NmiAx", --auth token

    from = "no-reply@namelessserver.net", --the mail address error have to be send from
    to = "test@namelessys.de", --the mail address error have to be send to.
}

--===== local funcs ======--
local function mail(subject, text, ...)
    local additional = {...}

    for _, arg in ipairs(additional) do
        text = text .. tostring(arg)
    end

    os.execute("echo '" .. text .. "' | mail -r " .. conf.from .. " -s '" .. subject .. "' " .. conf.to)
end
if type(conf.from) ~= "string" or type(conf.to) ~= "string" then
    print("WARN: No mail addresses set!")
    mail = function() end
end

local function error(...)
    io.stderr:write(...)
    io.stderr:flush()
    mail("[" .. conf.name .. "]: Cant pull backup: " .. conf.backup, table.concat({...}))
end

--===== prog start =====--
local damsClient = require("DamsClient").new({uri = conf.uri})
local ut = require("UT")
local argparse = require("argparse")

do --parse args 
    local parser = argparse("sendPullRequest", "A lua client to request the pulling of backups from a DAMS API")

    parser:flag("-v --version", "Prints the version and exits."):target("version")
    parser:flag("-E --error", "Simulates an error and exits."):target("simError")

    parser:option("-b --backup", "Defines the backup that have to be pulled."):target("backup")
    parser:option("-u --uri", "Defines the URI the request have to be send to."):target("uri")
    parser:option("-n --name", "Defines the name the client have to introduce itself."):target("name")
    parser:option("-T --token", "The auth token. WARN: if you pass the token this way it can be seen in command history!"):target("token")
    parser:option("-f --from", "The mail address error mails are sended from."):target("from")
    parser:option("-t --to", "The mail address error mails are sended to."):target("to")

    args = parser:parse()

    for i, v in pairs(args) do
        conf[i] = v
    end

    if args.version then
        print(version)
        os.exit(0)
    end

    if args.simError then
        error("Simlulated error\n")
        os.exit(1)
    end
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
