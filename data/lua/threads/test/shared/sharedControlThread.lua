log("--===== SHARED CONTROL THREAD START ======--")


while env.isRunning() and false do
	--print(shared.testVal1)
end


env.event.listen("sharedTest", function()
	log("--=== Shared test ===--")
	
	--restart sharing manager 
	env.thread.getChannel("SHARED_REQUEST"):push({
		request = "stop",
		id = env.getThreadInfos().id,
	})
	env.startFileThread("lua/threads/sharingManager.lua", "SHARING_MANAGER")

	--reload shared
	loadfile("lua/env/init/30_tShared.lua")(env)

	--start shared test
	loadfile("lua/test/sharedTest.lua")(env)
	
end)

log("--===== SHARED CONTROL THREAD END ======--")