
local utils = require "lua/system/utils_3scale"
local getProductInfo = require "lua/system/getProductInfo"
--local cjson = require "cjson"
local path = utils.split(ngx.var.request," ")[2]
--local user_script_file = ngx.re.match(path,[=[^\/v1\/triggers\/([a-zA-Z0-9-_]+)]=])[1]
local theSplit = ngx.re.match(path,[=[^\/v1\/geocode\/([-+]?[0-9]*\.?[0-9]+)\/([-+]?[0-9]*\.?[0-9]+)\/triggers\/(.*)\.json]=])
local lat  = theSplit[1]
local lon = theSplit[2]
local user_script_file = theSplit[3]

local post_data = ngx.req.get_body_data()

local atomicApi = getProductInfo.getAtomicApi(user_script_file)
local postData = getProductInfo.getPost(post_data, "temperature")
local apiData = getProductInfo.readAtomicApi(atomicApi, postData['lat'], postData['lng'])

    
process_function = loadfile(ngx.var.lua_user_scripts_path..user_script_file..".lua")
ngx.say(ngx.var.lua_user_scripts_path..user_script_file..".lua")

if (process_function == nil) then
  ngx.exit(ngx.HTTP_NOT_FOUND)
else
  readAtomicData = process_function()
  if (process_trigger_data == nil) then
    ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
  end
end

local timeout_response = function()
  debug.sethook()
  error("The lua script tem_exceeds has timed out!!")
end
process_trigger_data(apiData, postData['val'],postData['unit']);
