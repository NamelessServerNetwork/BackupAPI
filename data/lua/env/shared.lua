local shared = {
	__internal = {
		buffer = {},
	},
}


--=== set meta tables ===--
debug.setFuncPrefix("[SHARED]")
dlog("Set metatables")

setmetatable(shared, {
	__index = function(_, index)
		print(index)
	end,
	__newindex = function(_, index)
		print(index)
	end,
})



_G.shared = shared
return shared