return function(password) --ToDo: add argon2 hash.
	return "hash_" .. password
end