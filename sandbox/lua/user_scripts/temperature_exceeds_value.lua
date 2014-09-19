--[[
Example of a user script
]]--

return function()
    local utils = require "lua/system/utils_3scale"
    local cjson = require "cjson"
    local zlib = require "zlib"

    local res = ngx.location.capture("/api/da76745e63b41051/geolookup/q/94110.json")
    local stream_in = zlib.inflate(res.body)
    local content = stream_in:read("*a")
    stream_in:close()

    ngx.say(content)
    ngx.exit(ngx.HTTP_OK)
end
