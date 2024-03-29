local com = require "component"
local knn = require "knn"

local ibl = {}

function ibl.readData(file)
  local handle, reason = io.open(file, "r")
  if not handle then
    return nil, reason
  end
  local function readLine(line)
    if line:match("^%s*#") then
      return nil
    else
      local num, class = line:match("^%s*(%d*%.?%d*)%s*;%s*([%a%d_]+)")
      return tonumber(num), class
    end
  end
  local data = {}
  for line in handle:lines() do
    local tmp, num, class = {}, readLine(line)
    if num then
      tmp[1] = num
      tmp.class = class
      table.insert(data, tmp)
    end
  end
  return data
end

function ibl.makeSet(arg, ...)
  if type(arg) ~= "table" then
    arg = table.pack(arg, ...)
  end
  local ret = {}
  for i=1,#arg do
    ret[arg[i]] = true
  end
  return ret
end

function ibl.findValuables(protos, value, depth, range)
  local geo = com.geolyzer
  local locations = {}
  for x=-range, range do
    for z=-range, range do
      local s = geo.scan(x, z)
      for y=-depth, depth do
        local h = s[33 + y]
        local class = knn.knn(h, 1, protos, knn.euclid1D)
        if value[class] then
          table.insert(locations, {x=x, z=z, y=y})
        end
      end
    end
  end
  return locations
end

return ibl
