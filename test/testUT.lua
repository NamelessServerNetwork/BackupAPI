package.path = package.path .. "../data/lua/libs/?.lua;../data/lua/libs/thirdParty/?.lua;/home/noname/.luarocks/share/lua/5.1/?.lua;libs/?.lua"
package.cpath = package.cpath .. "../data/bin/libs/?.so;/home/noname/.luarocks/lib/lua/5.1/?.so"

package.loaded.UT = nil

local ut = require("UT")

print("Testing UT: " .. ut.getVersion())

print(ut.tostring({
    false,
    true,
    [true] = "t",
    test = true,

}))