return function(path)
    local siteCode = env.lib.ut.readFile(path)

    if not siteCode then
        return false, "File not found"
    end

    siteCode = "local args = {...}; local requestData, cookie, session = args[1], env.cookie, env.session; " .. siteCode
    return load(siteCode)
end