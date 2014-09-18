--[[
Example of a user script
]]--

return function()
    local utils = require "lua/system/utils_3scale"
    local cjson = require "cjson"
    local zlib = require "lzlib"
  local path = utils.split(ngx.var.request," ")[2]
  local res = ngx.location.capture("/api/da76745e63b41051/geolookup/q/94110.json")
  --ngx.header.content_type = "text/html"
  --ngx.say(path.." rules!")
    local result = cjson.decode(res.body)
    ngx.print(result)
  ngx.exit(ngx.HTTP_OK)
end
