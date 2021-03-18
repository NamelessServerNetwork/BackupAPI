local version, args = ...

local main = loadfile("lua/core/main.lua")(version)

--===== parse devConf/args =====--
main.devConf = loadfile("lua/devConf.lua")()
main.args = loadfile("lua/init/parseArgs.lua")(main, args) --parse args

--===== set debug =====--
print(loadfile("lua/core/debug.lua"))
main.debug = loadfile("lua/core/debug.lua")(main)

--===== set local init functions =====--
local orgRequire = require

local function require(p)
	debug.setFuncPrefix("[REQUIRE]")
	dlog(tostring(p))
	return orgRequire(p)
end

--===== start initialisation =====--
debug.setLogPrefix("[INIT]")

print("--===== Starting DAMS " .. tostring(main.version) .. " =====--")
log("Start initialization")

dlog("Setting up require paths")
package.path = package.path .. ";" .. main.devConf.requirePath

dlog("Loading libs")
main.ut = require("lua.libs.UT")

dlog("Loading data")


--===== load core files =====--
dlog("Loading core files")
main.terminal = loadfile("lua/core/terminal.lua")(main)
loadfile("lua/core/shutdown.lua")(main)

loadfile("lua/init/test.lua")(main)



os.exit(0)

return true, 0