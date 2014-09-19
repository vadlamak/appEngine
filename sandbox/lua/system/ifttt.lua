
local utils = require "lua/system/utils_3scale"
local getProductInfo = require "lua/system/getProductInfo"
--local cjson = require "cjson"
local path = utils.split(ngx.var.request," ")[2]
--local user_script_file = ngx.re.match(path,[=[^\/v1\/triggers\/([a-zA-Z0-9-_]+)]=])[1]
local theSplit = ngx.re.match(path,[=[^\/v1\/geocode\/([-+]?[0-9]*\.?[0-9]+)\/([-+]?[0-9]*\.?[0-9]+)\/triggers\/(.*)\.json]=])
local lat  = theSplit[1]
local lon = theSplit[2]
local user_script_file = theSplit[3]

local atomicApi = getProductInfo.getAtomicApi(user_script_file)
    --ngx.say(type(getProductInfo))
    ngx.say(atomicApi)

lc = loadfile(ngx.var.lua_user_scripts_path..user_script_file..".lua")
--ngx.say(ngx.var.lua_user_scripts_path..user_script_file..".lua")
--ngx.say("hello?")

local args = ngx.req.get_uri_args()
--for k, v in pairs(args) do ngx.say(k,v) end

if (lc == nil) then
  ngx.exit(ngx.HTTP_NOT_FOUND)
else
  user_function = lc()
  if (user_function == nil) then
    ngx.exit(ngx.HTTP_NOT_FOUND)
  end
end

local timeout_response = function()
  debug.sethook()
  error("The lua script tem_exceeds has timed out!!")
end
user_function();
