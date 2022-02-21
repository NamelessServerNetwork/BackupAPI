local env, shared, requestData = ...

print(env, shared, requestData)

print(shared.testValue)

shared.testValue = requestData.request.newValue

return "T1"