local ibl  = require "ibl"
local rpc  = require "rpc"
local lama = require "lama"

local ibm = {}

local function say(pr, msg)
  if pr then
    io.write(msg)
  end
end

function ibm.locateMineReturn(proto, valuables, depth, range, pr)
  local sx, sy, sz = lama.getPosition()
  local sf         = lama.getOrientation()
  ibm.locateAndMine(proto, valuables, depth, range, pr)
  say(pr, "Returning to starting position")
  lama.goTo(sx, sy, sz, true)
  lama.turn(sf)
end

function ibm.locateAndMine(proto, valuables, depth, range, pr)
  say(pr, "Start finding valuables\n")
  local locs = ibl.findValuables(proto, valuables, depth, range)
  say(pr, "Starting route planning\n")
  local route = rpc.rpc(locs, 1000)
  say(pr, "Retrieving found valuables\n")
  return lama.followPath(route, true)
end

return ibm
