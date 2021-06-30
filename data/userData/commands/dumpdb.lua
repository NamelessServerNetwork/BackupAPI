local env, args = ...
local dbTable = args[1]
local values = args[2]

if type(dbTable) ~= "string" then
	err("No table given")
	return 1
elseif type(values) ~= "string" then
	err("No value names given")
	return 1
end

env.userDB:exec([[SELECT ]] .. values .. [[, rowid FROM ]] .. dbTable .. [[]], function(udata, cols, values, names)	
	local rowid
	
	for i = 1, cols do
		if names[i] == "rowid" then
			rowid = values[i] 
			break
		end
	end
	
	print(tostring(dbTable) .. ": " .. tostring(rowid))
	
	for i = 1, cols do
		if names[i] ~= "rowid" then
			print("", tostring(names[i]) .. ": " .. tostring(values[i]))
		end
	end
	return 0
end)

return 0