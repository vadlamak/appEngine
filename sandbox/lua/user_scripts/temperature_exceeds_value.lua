--[[
Example of a user script
]]--

return function()
    local utils = require "lua/system/utils_3scale"
    local cjson = require "cjson"
    local zlib = require "zlib"
    local path = utils.split(ngx.var.request," ")[2]
    local res = ngx.location.capture("/api/da76745e63b41051/geolookup/q/94110.json")
    local buff = res.body
   -- local response=zlib.inflate(buff)
    local stream_in = zlib.inflate(buff)
    local result = stream_in:read("*a")
     stream_in:close()
    --local response=zlib.version()

  --ngx.header.content_type = "text/html"
  --ngx.say(path.." rules!")
    --local result = cjson.decode(res.body)
    ngx.say(result)
  ngx.exit(ngx.HTTP_OK)
end
