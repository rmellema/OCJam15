local function findClosestsPoints(point, data, dist)
  local sorted, distances = {}, {}
  for _, p in ipairs(data) do
    local d = dist(point, p)
    local i = 1
    while i <= #distances and distances[i] <= d do
      i = i + 1
    end
    table.insert(distances, i, d)
    table.insert(sorted,    i, p)
  end
  return sorted, distances
end

local function knn(point, k, data, dist)
  local close, dists = findClosestsPoints(point, data, dist)
  local occur = {}
  for i=1, k do
    local p = close[i]
    occur[p.class] = (occur[p.class] or 0) + 1
  end
  local maxNum, maxClass = 0, ""
  for c, n in pairs(occur) do
    if n > maxNum then
      maxNum, maxClass = n, c
    end
  end
  return maxClass
end

local function euclid1D(x, y)
  x = (type(x) == "table" and x[1] or x)
  y = (type(y) == "table" and y[1] or y)
  return math.abs(x-y)
end

local function euclid(x, y)
  local sum = 0
  for i=1,#x do
    sum = sum + (x[i]-y[i])^2
  end
  return math.sqrt(sum)
end

return {knn = knn, euclid1D = euclid1D, euclid=euclid}

