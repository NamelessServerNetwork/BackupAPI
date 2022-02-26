package.path = package.path .. "../data/lua/libs/?.lua;../data/lua/libs/thirdParty/?.lua;/home/noname/.luarocks/share/lua/5.1/?.lua;libs/?.lua"
package.cpath = package.cpath .. "../data/bin/libs/?.so;/home/noname/.luarocks/lib/lua/5.1/?.so"

package.loaded.ocl = nil
local ocl = require("ocl")

ocl.open("logs/TEST.log")

ocl.add("TEST")
ocl.add("TEST2")

ocl.close()