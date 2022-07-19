local s = "test=this+%3D+test%0D%0Abelieve%3F%0D%0Ano%21%0D%0Agood%23%22%22&say=Hi&to=Mom"
local convertedTable = {}

-- I have no idea what actually happens here...
-- https://stackoverflow.com/questions/20282054/how-to-urldecode-a-request-uri-string-in-lua
local hex_to_char = function(x)
    return string.char(tonumber(x, 16))
end
local unescape = function(url)
    return url:gsub("%%(%x%x)", hex_to_char)
end

-- split the string and convert it into a table
for s in string.gmatch(s, "[^&]+") do
    local index, value
    for s2 in string.gmatch(s, "[^=]+") do
        if index == nil then
            index = s2
        else
            value = s2
        end
    end
    convertedTable[index] = string.gsub(unescape(value), "+", " ")
end


print(require("data/lua/libs/UT").tostring(convertedTable))


