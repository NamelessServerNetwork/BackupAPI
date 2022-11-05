#!/bin/lua
package.path = "libs/?.lua;" .. package.path

local ut = require("UT")

local client = require("DamsClient").new({
    uri = "https://damsdev.namelessserver.net",
})

local suc, headers, response = client:request({
    action = "test",
    value = "TEST",
}, {})

print("\nSUC")
print(suc)
print("\nHEADERS")
print(ut.tostring(headers))
print("\nRESPONSE")
print(ut.tostring(response))

