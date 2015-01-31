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

function ipp.ipp(points, max)
  max = max or 20
  local ret = points
  for i=1,max do
    local start, len = math.random(#points), math.random(#points/2)
    local cost = length(points)
    ret = reverse(points, start, len)
    if length(ret) < cost then
      points = ret
    end
  end
  return ret
end

return {ipp = ipp.ipp, reverse = reverse}
