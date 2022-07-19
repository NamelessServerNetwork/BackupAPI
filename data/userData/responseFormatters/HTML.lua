local resData = ...

if resData.success == false then
    return env.lib.ut.tostring(resData)
end

return env.lib.ut.tostring(resData.returnValue)