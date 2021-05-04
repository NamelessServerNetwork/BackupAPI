local env = ...

dlog("Loading libs")

env.thread = require("love.thread")
env.timer = require("love.timer")
env.serialization = require("serpent")

env.cqueues = require("cqueues")