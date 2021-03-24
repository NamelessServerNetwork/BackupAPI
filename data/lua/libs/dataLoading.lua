local env, shared = ...

local DL = {}

--===== lib functions =====--
function loadData(target, dir, logFuncs, overwrite, subDirs, structured, loadFunc)
	local path = dir .. "/" --= env.shell.getWorkingDirectory() .. "/" .. dir .. "/"
	logFuncs = logFuncs or {}
	local print = logFuncs.log or dlog
	local warn = logFuncs.warn or warn
	local onError = logFuncs.error or err
	
	subDirs = env.ut.parseArgs(subDirs, true)
	
	for _, file in pairs(env.fs.getDirectoryItems(path)) do
		local p, name, ending = env.ut.seperatePath(path .. file)
		
		--print(p)
		
		if name ~= "gitignore" and name ~= "gitkeep" then
			if env.fs.getInfo(path .. file).type == "directory" and subDirs then
				if structured then
					if target[string.sub(file, 0, #file)] == nil or overwrite then
						target[string.sub(file, 0, #file)] = {}
						loadData(target[string.sub(file, 0, #file)], dir .. "/" .. file, logFuncs, overwrite, subDirs, structured)
					else
						onError("[DLF]: Target already existing!: " .. file .. " :" .. tostring(target))
					end
				else
					loadData(target, path .. file, logFuncs, overwrite, subDirs, structured)
				end
			elseif target[name] == nil or overwrite then
				local debugString = ""
				if target[name] == nil then
					debugString = "[DLF]: Loading file: " .. dir .. "/" .. file .. ": "
				else
					debugString = "[DLF]: Reloading file: " .. dir .. "/" .. file .. ": "
				end
				
				local suc, err 
				if loadFunc ~= nil then
					suc, err = loadFunc(path .. file)
				else
					suc, err = loadfile(path .. file)
				end
				
				if type(suc) == "function" then print("T1")
					target[name or string.sub(p, 0, #p -1)] = suc(env)
				elseif type(suc) == "table" then
					target[name or string.sub(p, 0, #p -1)] = suc
				end
				
				if env.isDev then
					if suc == nil then
						warn("[DLF] Failed to load file: " .. dir .. "/" .. file .. ": " .. tostring(err))
					else
						print(debugString .. tostring(suc))
					end
				end
			end
		end
	end
end

--===== set functions =====--
DL.loadData = loadData


return DL