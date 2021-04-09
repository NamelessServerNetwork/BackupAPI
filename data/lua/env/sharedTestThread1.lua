local env, shared = loadfile("data/lua/env/envInit.lua")("[SHARED_TEST_THREAD#1]")

print("--===== SHARED TEST THREAD#1 START ======--")

--shared.test = "T1"
--print(shared.test)
print("TEST")


print("--===== SHARED TEST THREAD#1 END ======--")