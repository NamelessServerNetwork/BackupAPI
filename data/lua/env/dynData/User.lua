local User = {}

function User.new(args)
	local self = setmetatable({}, {__index = User})
	
	
	
	self.username = nil
	self.id = nil
	
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