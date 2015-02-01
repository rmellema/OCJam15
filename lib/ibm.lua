local ibl  = require "ibl"
local rpc  = require "rpc"
local lama = require "lama"

local ibm = {}

function ibm.locateAndMine(proto, valuables, depth, range)
  local locs = ibl.findValuables(proto, valuables, depth, range)
  local route = rpc.rpc(locs, 1000)
  return lama.followPath(route, true)
end

return ibm
