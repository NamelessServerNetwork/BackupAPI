--ToDo: replace string.len with utf8.len when avaiable.
local env = ...
local terminal = {}

--===== require libs =====--
local getch = require("getch")
local textInput = loadfile(env.devConf.terminalPath .. "TextInput.lua")()
local constants = require(env.devConf.terminalPath .. "terminalConstants")
local utf8 = require("utf8")
local thread = require("love.thread")

--===== set constants =====--
local terminalSizeRefreshTime = 1

local ansi = constants.ansi
local keyTable = constants.keyTable

--===== set local variables =====--
local writeCursorPos = 1
local terminalLength, terminalHeight = 115, 70
local previusTerminalSizeRefreshTime = 0
local drawNeeded = true

local textBox = textInput.new()

local debug_print = thread.getChannel("debug_print")

--===== set local functions =====--
--local ioWrite = io.write
local ioWrite = env.org.io.write
local function w(...)
	ioWrite(...)
end

local function getTerminalSize()
	local timeSeconds = os.time(os.date("*t"))
	--ToDo: needs to be fixed
	--[[
	if previusTerminalSizeRefreshTime + terminalSizeRefreshTime < timeSeconds then
		_, _, terminalLength = os.execute("return $(tput cols)")
		_, _, terminalHeight = os.execute("return $(tput lines)")
		previusTerminalSizeRefreshTime = timeSeconds
	end
	]]
	
	return terminalLength, terminalHeight
end

local function resetCursor()
	local terminalLength, terminalHeight = getTerminalSize()
	local _, cursorPos = textBox:get(terminalLength)
	
	w(ansi.setCursor:format(terminalHeight, cursorPos))
end

local function getMsg(...)
	local msgs = ""
	if #{...} == 0 then
		msgs = "nil"
	else
		for _, msg in pairs({...}) do
			msgs = msgs .. tostring(msg) .. "  "
		end
	end
	return msgs
end

local function write(...) --not used anymore! --io.write() replacement
	local _, terminalHeight = getTerminalSize()
	
	w(ansi.setCursor:format(terminalHeight -1, writeCursorPos))
	
	for _, arg in pairs({...}) do
		writeCursorPos = writeCursorPos + utf8.len(tostring(arg))
	end
	
	w(getMsg(...))
	resetCursor()
end

local function print(...)
	local _, terminalHeight = getTerminalSize()
	w(ansi.setCursor:format(terminalHeight, writeCursorPos))
	w(ansi.clearLine)
	w(getMsg(...))
	w("\n")
	writeCursorPos = 1 --used for write() / io.write()
	resetCursor()
end

local function get_mbs(callback, keyTable, max_i, i)
	assert(type(keyTable)=="table")
	i = tonumber(i) or 1
	max_i = tonumber(max_i) or 10
	local key_code = callback(env.devConf.sleepTime)
	--print(key_code)
	if i>max_i then
		return key_code, false
	end
	local key_resolved = keyTable[key_code]
	if type(key_resolved) == "function" then
		key_resolved = key_resolved(callback, key_code)
	end
	if type(key_resolved) == "table" then
		-- we're in a multibyte sequence, get more characters recursively(with maximum limit)
		return get_mbs(callback, key_resolved, max_i, i+1)
	elseif key_resolved then
		-- we resolved a multibyte sequence
		return key_code, key_resolved
	else
		-- Not in a multibyte sequence
		return key_code
	end
end

local function draw(text, cursorPos)
	local _, terminalHeight = getTerminalSize()
	w(ansi.setCursor:format(terminalHeight, 1))
	w(ansi.clearLine)
	w(text)
	resetCursor()
	io.flush()
end

--===== initialisation =====--
textBox.listedFunction = function(t)
	env.terminal.input(t.text)
end
textBox.autoCompFunction = function(t)
	env.terminal.autoComp(t)
end

--===== main functions =====--
function terminal.update()
	local code, action = get_mbs(getch.non_blocking, keyTable)
	
	if code ~= nil then
		--print(code, action)
		
		if action == "RELOAD" then
			loadfile("lua/core/reload.lua")(env, shared)
		else
			textBox:update(terminalLength, code, action)
		end
		drawNeeded = true
	end
	
	while debug_print:peek() ~= nil and true do
		print(debug_print:pop())
		drawNeeded = true
	end
end

function terminal.draw()
	if not drawNeeded then return false end
	
	local terminalLength = getTerminalSize()
	
	draw(textBox:get(terminalLength))
	
	drawNeeded = false
end

terminal.print = print
--terminal.write = write

_G.print = print
--_G.io.write = write

return terminal
