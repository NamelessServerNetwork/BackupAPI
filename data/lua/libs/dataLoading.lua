local env, shared = ...

local DL = {}

--===== lib functions =====--
local function executeFile(file)

end

local function loadDir(target, dir, logFuncs, overwrite, subDirs, structured, numericStructured, loadFunc)
	local path = dir .. "/" --= env.shell.getWorkingDirectory() .. "/" .. dir .. "/"
	logFuncs = logFuncs or {}
	local print = logFuncs.log or dlog
	local warn = logFuncs.warn or warn
	local onError = logFuncs.error or err
	local loadedFiles = 0
	local failedFiles = 0
	
	subDirs = env.ut.parseArgs(subDirs, true)
	
	for _, file in pairs(env.fs.getDirectoryItems(path)) do
		local p, name, ending = env.ut.seperatePath(path .. file)
		
		--print(p)
		
		if name ~= "gitignore" and name ~= "gitkeep" then
			if env.fs.getInfo(path .. file).type == "directory" and subDirs then
				if structured then
					if target[string.sub(file, 0, #file)] == nil or overwrite then
						target[string.sub(file, 0, #file)] = {}
						local s, f = loadDir(target[string.sub(file, 0, #file)], dir .. "/" .. file, logFuncs, overwrite, subDirs, structured)
						loadedFiles = loadedFiles + s
						failedFiles = failedFiles + f
					else
						onError("[DLF]: Target already existing!: " .. file .. " :" .. tostring(target))
					end
				else
					local s, f = loadDir(target, path .. file, logFuncs, overwrite, subDirs, structured)
					loadedFiles = loadedFiles + s
					failedFiles = failedFiles + f
				end
			elseif target[name] == nil or overwrite then
				local debugString = ""
				if target[name] == nil then
					debugString = "Loading file: " .. dir .. "/" .. file .. ": "
				else
					debugString = "Reloading file: " .. dir .. "/" .. file .. ": "
				end
				
				local suc, err 
				if loadFunc ~= nil then
					suc, err = loadFunc(path .. file)
				else
					suc, err = loadfile(path .. file)
				end
				
				--target[name or string.sub(p, 0, #p -1)] = suc
				if numericStructured then
					local order = 50
					for fileOrder in string.gmatch(name, "([^_]+)") do
						order = tonumber(fileOrder)
						break
					end
					if order == nil then
						order = 50
					end
					if target[order] == nil then
						target[order] = {}
					end
					target[order][name] = suc
				else
					target[name] = suc
				end
				
				--[[
				if type(suc) == "function" then print("T1")
					target[name or string.sub(p, 0, #p -1)] = suc(env)
				elseif type(suc) == "table" then
					target[name or string.sub(p, 0, #p -1)] = suc
				end
				]]
				
				if suc == nil then 
					failedFiles = failedFiles +1
					warn("Failed to load file: " .. dir .. "/" .. file .. ": " .. tostring(err))
				else
					loadedFiles = loadedFiles +1
					dlog(debugString .. tostring(suc))
				end
			end
		end
	end
	return loadedFiles, failedFiles
end

local function load(target, dir, name, sturctured, numericStructured, overwrite)
	local loadedFiles, failedFiles = 0, 0
	if name == nil then name = dir end 
	
	dlog("Loading: " .. name .. " (" .. dir .. ")")
	loadedFiles, failedFiles = loadDir(target, dir, nil, overwrite, nil, sturctured, numericStructured)
	log("Successfully loaded " .. tostring(loadedFiles) .. " " .. name)
	if failedFiles > 0 then
		warn("Failed to load " .. tostring(failedFiles) .. " " .. name)
	end
	dlog("Loading done: " .. name .. " (" .. dir .. ")")
	return target
end

local function executeDir(dir, name)
	name = name or ""
	dlog("Execute: " .. name .. " (" .. dir .. ")")
	local scripts = load({}, dir, name, false, true)
	
	for order = 0, 100 do
		local scripts = scripts[order]
		if scripts ~= nil then
			for name, script in pairs(scripts) do
				dlog("Execute: " .. name)
				script()
			end
		end
	end
	dlog("Executing done: " .. name .. " (" .. dir .. ")")
end

--===== set functions =====--
--DL.loadData = loadData
DL.load = load
DL.executeDir = executeDir

return DL