local env = ...

env.debug.setFuncPrefix("[SHARED_TEST_SCRIPT]", true)

log("Shared test script")

--env.shared.t1.t2.test = "NEW TEST VALUE"
--env.shared.t1.test = "NEW TEST VALUE"

local function wait(id, timeout)
    env.thread.getChannel("SHARING_TEST_THREAD_WAIT#" .. tostring(id)):demand(timeout)
end

--log(env.tostring(t2("lock")))
local testThreads = 1
for c = 0, testThreads -1 do
    local id = env.thread.getChannel("SHARING_TEST_THREAD_INIT"):demand()
    log("sharing test thread init #" .. tostring(id) .. " done")
end

log("--=== Start test ===--")


env.shared.t1.t2("lock")

env.event.push("STT#1")
env.event.push("STT#2")
wait(1, 1)
wait(2, 1)

log(env.shared.t1.t2)

--env.shared.t1.t2("unlock")

log(" Test done ")

--log("1:", t.t2)
--log("2:", t.t2.test)

--log("VALUE: ", env.tostring(env.shared.t1.t2.test))
--log("VALUE: ", env.tostring(env.shared.t1.t2.number))

--[[
env.shared.t1 = {}
env.shared.t1.t2 = {}
env.shared.t1.t2.string = "NEW STRING VALUE"
env.shared.t1.t2.number = 333



local t1 = env.shared.t1
local t2 = env.shared.t1.t2

print(t1)
print(t2.string)
print(t1.t2.number)

print(env.shared)
print(t1)
]]

if true then
    env.thread.getChannel("SHARED_REQUEST"):push({
        request = "dump_lockTable",
        id = env.getThreadInfos().id,
    })
end

if false then
    env.thread.getChannel("SHARED_REQUEST"):push({
        request = "dump",
        id = env.getThreadInfos().id,
    })
end