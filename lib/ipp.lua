local ipp = {}

local function manhattan(o, t)
  local sum = 0
  for k, _ in pairs(o) do
    sum = sum + math.abs(o[k] -t[k])
  end
  return sum
end

local function length(p)
  local sum = 0
  for i=2, #p do
    sum = sum + manhattan(p[i-1], p[i])
  end
  return sum
end

local function reverse(all, start, length)
  local stop, ret = start + length, {}
  if stop > #all then
    stop = #all
    length = stop - start
  end
  for i=1,start-1 do
    ret[i] = all[i]
  end
  for i=0,length do
    ret[start + i] = all[stop - i]
  end
  for i=stop + 1, #all do
    ret[i] = all[i]
  end
  return ret
end

function ipp.shortenPath(path, max)
  max = max or 20
  local ret = path
  for i=1,max do
    local start, len = math.random(#path), math.random(#path/2)
    local cost = length(path)
    ret = reverse(path, start, len)
    if length(ret) < cost then
      path = ret
    end
  end
  return ret
end

function ipp.coordsToPath(p)
  local ret = {p[1]}
  for i=2, #p do
    ret[i] = {x = p[i].x - p[i-1].x, 
              y = p[i].y - p[i-1].y, 
              z = p[i].z - p[i-1].z}
  end
  return ret
end

function ipp.ipp(path, max)
  local p = ipp.shortenPath(path, max)
  return ipp.coordsToPath(p)
end

return ipp
