local _M = {} -- public interface

local cjson = require "cjson"
local zlib = require "zlib"

local lookup  = { 
                temperature_rises_above = "history",
                temperature_drops_below = "history" 
               } 
function _M.getAtomicApi(product)
    result = lookup[product]
    if (result == nil ) then
        ngx.exit(ngx.HTTP_BAD_REQUEST)
    end
  return result
end

function _M.readAtomicApi(apiname,lat,lng)

    --local uri = string.format("/api/da76745e63b41051/%s/q/%f,%f.json",apiname,lat,lng)
    local uri = string.format("/v1/geocode/%f/%f/%s.json?language=en-US&apiKey=51222bf098c6a59c4ee6af8d5a57128b&units=e",lat,lng,apiname)
    local res = ngx.location.capture(uri) 

    local stream_in = zlib.inflate(res.body) 
    local content = stream_in:read("*a") 
    stream_in:close()

    if (content==nil) then
        ngx.exit(ngx.HTTP_GATEWAY_TIMEOUT)
    end
    
    jsonTable=assert(cjson.decode(content))

    

    --ngx.say(content)

  return jsonTable
end

function _M.getPost(post_data, trigger_field)
    ret = {} 
    local obj = cjson.decode(post_data)
    local lat = obj['triggerFields']['location']['lat']
    local lng = obj['triggerFields']['location']['lng']
    local val = obj['triggerFields'][trigger_field]
    local unit = obj['triggerFields']['unit']

    ret = {["lat"]=lat,["lng"]=lng,["val"]=val,["unit"]=unit}

    return ret
end


return _M
