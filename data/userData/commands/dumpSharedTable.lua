env.thread.getChannel("SHARED_REQUEST"):push({
    request = "dump",
    id = env.getThreadInfos().id,
})