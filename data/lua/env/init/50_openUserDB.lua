log("Open user DB")
env.userDB = env.lib.sqlite.open(env.devConf.userLoginDatabasePath)