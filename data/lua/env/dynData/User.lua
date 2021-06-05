local User = {}

function User.new(args)
	local self = setmetatable({}, {__index = User})
	
	assert(type(args) == "table", "No valid args given")
	
	self.name = args.username 
	self.id = 1 --ToDo: add database lookup based on username
	
	self.loginToken = args.loginToken
	
	return self
end

function User:getData()
	local userData = {}
	for i, v in pairs(self) do
		if type(v) ~= "function" then
			userData[i] = v
		end
	end
	return userData
end


return User