
local utils = require "lua/system/utils_3scale"
local getProductInfo = require "lua/system/getProductInfo"


local path = utils.split(ngx.var.request," ")[2]
local theSplit = ngx.re.match(path,[=[^\/v1\/geocode\/([-+]?[0-9]*\.?[0-9]+)\/([-+]?[0-9]*\.?[0-9]+)\/triggers\/(.*)\.json]=])
local user_script_file = theSplit[3]


local atomicApi = getProductInfo.getAtomicApi(user_script_file)
local postData = getProductInfo.getPost(ngx.req.get_body_data(), "temperature")
local apiData = getProductInfo.readAtomicApi(atomicApi, postData['lat'], postData['lng'])

--[[
Load A file containing the lua template for transforming our API response into a trigger response for IFTTT
--]] 
process_function = loadfile(ngx.var.lua_user_scripts_path..user_script_file..".lua")
ngx.say(ngx.var.lua_user_scripts_path..user_script_file..".lua")

if (process_function == nil) then
    ngx.say("nf")
  ngx.exit(ngx.HTTP_NOT_FOUND)
else
  process_trigger_data = process_function()
  if (process_trigger_data == nil) then
    ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
  end
end

local timeout_response = function()
  debug.sethook()
  error("The lua script tem_exceeds has timed out!!")
end
process_trigger_data(apiData, postData['val'],postData['unit']);
