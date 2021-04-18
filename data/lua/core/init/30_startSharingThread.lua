local env = ...

dlog("Starting sharing thread")

env.startFileThread("lua/threads/sharingManager.lua", "SHARING_MANAGER")