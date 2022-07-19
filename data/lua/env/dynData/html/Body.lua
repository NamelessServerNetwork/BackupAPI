local Body = {}

log("EXEC!")

function Body.new()
    local self = setmetatable({}, {__index = Body})

    self.content = {
        "<!DOCTYPE html> \n<html>",
    }

    return self
end

function Body:addRaw(text)
    table.insert(self.content, "\n" .. text .. "\n")
end

function Body:addRefButton(name, link)
    table.insert(self.content, [[
<a href="]]..link..[[">  
    <input type="button" value="]]..name..[["/>  
</a> 
]])
end

function Body:addAction(link, method, actions)
    local actionString = [[<form action="]]..link..[[" method="]]..method..[[">]]
    for _, action in pairs(actions) do
        if action[1] == "input" then
            if action.type == nil then
                action.type = "text"
            end
            actionString = actionString .. [[
<div>
    <label for="]]..action.name..[[">]]..action.name..[[</label>
    <input name="]]..action.name..[[" value="]]..action.value..[[">
</div>
]]
        elseif action[1] == "hidden" then
            actionString = actionString .. [[
<div>
    <input type="hidden" name="]]..action.name..[[" value="]]..action.value..[[">
</div>
]]
        elseif action[1] == "textarea" then
            actionString = actionString .. [[
<div>
    <textarea for="]]..action.name..[[" name="]]..action.name..[[">]]..action.value..[[</textarea>
</div>
]]
        elseif action[1] == "button" or action[1] == "submit" then
            if action.value == nil then
                action.value = action.name
            end
            actionString = actionString .. [[
<div>
    <button type="]]..action[1]..[[">]]..action.value..[[</button>
</div>
]]
        end
    end
    table.insert(self.content, actionString)
end

function Body:addHeader(level, text)
    table.insert(self.content, [[
<h]]..tostring(level)..[[>]]..tostring(text)..[[</h]]..tostring(level)..[[>
    ]])
end

function Body:addReturnButton(text, requestData)
    log(requestData.headers.referer)
    if requestData.headers.referer then
        local referer = requestData.headers.referer.value 
        table.insert(self.content, [[
<a href="]]..referer..[[">  
    <input type="button" value="]]..tostring(text)..[["/>  
</a>     
]])
    else
        table.insert(self.content, [[
<p>(Return button error. Please contacs an admin.)</p>
]])
    end
end

function Body:addP(text)
    table.insert(self.content, [[
<p>]]..tostring(text)..[[</p>
]])
end 

function Body:generateCode()
    local htmlCode = ""
    for _, c in pairs(self.content) do
        htmlCode = htmlCode .. c
    end
    return htmlCode .. "</html>"
end

return Body