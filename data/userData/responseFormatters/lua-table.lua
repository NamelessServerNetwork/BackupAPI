local resData = ...

local returnString = env.lib.serialization.dump(resData)

if type(returnString) == "string" then
    return true, returnString
else
    return false, returnString
end