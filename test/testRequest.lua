package.path = package.path .. "../data/lua/libs/?.lua;../data/lua/libs/thirdParty/?.lua;/home/noname/.luarocks/share/lua/5.1/?.lua;libs/?.lua"
package.cpath = package.cpath .. "../data/bin/libs/?.so;/home/noname/.luarocks/lib/lua/5.1/?.so"

local httpClient = require("http.client")
local httpRequest = require("http.request")
local httpWebsocket = require("http.websocket")
local ut = require("UT")

local connection = httpClient.connect({
    host = "localhost",
    port = 8023,
    tls = false,
})

local requestHandler = httpRequest.new_from_uri("http://127.0.0.1:8023")

requestHandler:set_body("{action = 'test1', newValue = 7}")
--requestHandler:set_body("do local _={action = 'test1', newValue = 7};return _; end")
requestHandler.headers:append("request-format", "lua-table2")
--requestHandler.headers:append("response-format", "lua-table")
requestHandler.headers:append("response-format", "readable-lua-table")

--print(ut.tostring(requestHandler.headers))


local headers, stream = requestHandler:go()

--print(headers, stream)

--print(ut.tostring(headers))
print(stream:get_body_as_string())

--[[
local ws = httpWebsocket.new_from_uri("http://localhost:8023")

print("T1")
print(ws:connect())
print("T2")
ws:send("TEST")
print("T3")
print(ws:recieve())
print("T4")
]]