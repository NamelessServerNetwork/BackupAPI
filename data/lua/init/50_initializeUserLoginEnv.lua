debug.setFuncPrefix("[USERLOGIN]")

log("Initialize user login env")

local DB

env.shared.openSessions = {}

dlog("Open login DB")
DB = dlog(env.lib.sqlite.open(env.devConf.userLoginDatabasePath))
DB:close()