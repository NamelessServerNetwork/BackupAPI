debug.setFuncPrefix("[DB]")
dlog("Prepare login DB")

local db, err = env.lib.sqlite.open(env.devConf.userLoginDatabasePath)
local createSysinfoEntry = true

ldlog(db, err)

dlog("Create tables")
log(db:exec([[
	CREATE TABLE sysinfo (
		userCount INTEGER NOT NULL
	);
]]))

log(db:exec([[
	CREATE TABLE users (
		username TEXT NOT NULL,
		password TEXT NOT NULL,
		id INTEGER NOT NULL
	);
]]))

log(db:exec([[
	CREATE TABLE permissions (
		permission TEXT NOT NULL,
		userID TEXT NOT NULL,
		value INTEGER NOT NULL
	);
]]))

dlog("Prepare sysinfo table")
log(env.userDB:exec([[
	SELECT userCount FROM sysinfo
]], function(udata,cols,values,names)
	for i=1,cols do 
		if names[i] == "userCount" then
			createSysinfoEntry = false
		end
	end
	return 0
end))

if createSysinfoEntry then
	log("Create sysinfo entry")
	db:exec([[INSERT INTO sysinfo VALUES (0);]])
end

db:close()