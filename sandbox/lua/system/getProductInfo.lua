local M = {} -- public interface

local lookup  = {   ["rises"] = "obs", ["drops"]="falls"
    }

function M.getAtomicApi(self)
  local result = "api"
  --local lookup = M.lookup
    ngx.say(lookup["rises"])
  return result
end

--M.lookup = {temperature_rises_above = "observation"}

return M
