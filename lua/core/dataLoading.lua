
function loadData(target, dir, func, logFuncs, overwrite, subDirs, structured, loadFunc)
	local id = 1
	if target.info ~= nil and target.info.amout ~= nil then
		id = target.info.amout +1
	end
	local path = global.shell.getWorkingDirectory() .. "/" .. dir .. "/"
	logFuncs = logFuncs or {}
	local print = logFuncs.log or global.log
	local warn = logFuncs.warn or global.warn
	local onError = logFuncs.error or global.error
	
	subDirs = global.ut.parseArgs(subDirs, true)
	
	for file in global.fs.list(path) do
		local p, name, ending = global.ut.seperatePath(file)
		
		if name ~= "gitignore" and name ~= "gitkeep" then
			if string.sub(file, #file) == "/" and subDirs then
				if structured then
					if target[string.sub(p, 0, #p -1)] == nil or target[string.sub(p, 0, #p -1)].structured == true or overwrite and not structured then
						target[string.sub(p, 0, #p -1)] = {structured = true}
						loadData(target[string.sub(p, 0, #p -1)], dir .. "/" .. p, func, logFuncs, overwrite, subDirs, structured)
					else
						onError("[DLF]: Target already existing!: " .. p .. " :" .. tostring(target))
					end
				else
					loadData(target, dir .. "/" .. p, func, logFuncs, overwrite, subDirs, structured)
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
				elseif ending == ".pic" then
					suc, err = global.image.load(path .. file)
					if suc ~= false then
						suc.format = "pic"
						suc.resX, suc.resY = suc[1], suc[2]
					end
				else
					suc, err = loadfile(path .. file)
				end
				
				if global.isDev then
					if suc == nil then
						warn("[DLF] Failed to load file: " .. dir .. "/" .. file .. ": " .. tostring(err))
					else
						print(debugString .. tostring(suc))
					end
				end
				
				if type(suc) == "function" then
					target[name or string.sub(p, 0, #p -1)] = suc(global)
				elseif type(suc) == "table" then
					target[name or string.sub(p, 0, #p -1)] = suc
				end
				
				local obj = target[name or string.sub(p, 0, #p -1)]
				if type(obj) == "table" then
					global.run(obj.init, obj)
				end
				
				if func ~= nil then
					func(name, id)
				end
				
				id = id +1
			end
		end
	end
	return id
end

local function loadFiles(target, name, func, directPath, subDirs, structured, loadFunc)
	local path = baseDir .. name
	subDirs = global.ut.parseArgs(subDirs, true)
	
	if directPath then
		path = directPath
	end
	
	if global.alreadyLoaded[path] ~= true or reload then
		if global.alreadyLoaded[path] ~= true then
			print("[DL]: Loading data group: " .. name .. ".")
		elseif reload then
			print("[DL]: Reloading data group: " .. name .. ".")
		end
		loadData(target, path, func, {log = print, warn = global.warn, error = print}, reload, subDirs, structured, loadFunc)
		global.alreadyLoaded[path] = true
		return true
	else
		print("[DL]: Data group already loaded: " .. name .. ".")
		return false
	end
end