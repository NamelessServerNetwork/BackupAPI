local env = ...

env.debug.setFuncPrefix("[SHARED_TEST_SCRIPT]", true)

log("Shared test script")

--env.shared.t1.t2.test = "NEW TEST VALUE"
--env.shared.t1.test = "NEW TEST VALUE"

local t = {
    t2 = {
        t3 = "t3",
    },
}


--log("1:", t.t2)
--log("2:", t.t2.test)


log(env.shared.t1.t2.test)


env.thread.getChannel("SHARED_REQUEST"):push({
    request = "dump",
    id = env.getThreadInfos().id,
})