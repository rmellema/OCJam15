local component = require "component"
local fs        = require "filesystem"
local knn       = require "knn"
local shell     = require "shell"

local function printUsage()
  io.write("usage: smine [--depth=num] [--min=num] [--range=num] [-d] file valuables ...\n")
end

local function readData(file)
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

-- Checking if we can run with the current configuration
if not component.isAvailable "geolyzer" then
  io.write("No geolyzer found, aborting!\n")
  return
end

local geolyzer  = component.geolyzer

local args, opts = shell.parse(...)

if #args < 2 then
  printUsage()
  return
end

local file = table.remove(args, 1)

if not fs.exists(shell.resolve(file)) then
  io.write("smine: " .. file .. ": No such file or directory")
  return
end

local depth, minFound, range = 16, 4, 16
if opts.depth then
  depth = tonumber(opts.depth)
  if not depth then
    io.write("smine: ".. opts.depth .. " is not a valid search depth\n")
    return
  end
end
if opts.min then
  minFound = tonumber(opts.min)
  if not minFound then
    io.write("smine: ".. opts.min .. " is not a valid minimum amount\n")
    return
  end
end
if opts.range then
  range = tonumber(opts.range)
  if not range then
    io.write("smine: ".. opts.range .. " is not a valid search range\n")
    return
  end
end
  
local up = not opts.d

-- Main
local proto = readData(file)

for i=1, #data do
  print(data[i][1], data[i].class)
end
