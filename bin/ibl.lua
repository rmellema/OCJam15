local component = require "component"
local fs        = require "filesystem"
local knn       = require "knn"
local shell     = require "shell"
local ibl       = require "ibl"

local function printUsage()
  io.write("usage: ibl [--depth=num] [--min=num] [--range=num] [-d] file valuables ...\n")
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
  io.write("ibl: " .. file .. ": No such file or directory")
  return
end

local depth, minFound, range = 16, 4, 16
if opts.depth then
  depth = tonumber(opts.depth)
  if not depth then
    io.write("ibl: ".. opts.depth .. " is not a valid search depth\n")
    return
  end
end
if opts.min then
  minFound = tonumber(opts.min)
  if not minFound then
    io.write("ibl: ".. opts.min .. " is not a valid minimum amount\n")
    return
  end
end
if opts.range then
  range = tonumber(opts.range)
  if not range then
    io.write("ibl: ".. opts.range .. " is not a valid search range\n")
    return
  end
end

local up = not opts.d

-- Main
local proto = ibl.readData(file)
local vals  = ibl.makeSet(args)
local locs  = ibl.findValuables(proto, vals, depth, range)

if type(opts.output) == "string" then
  print("Setting output to: "..opts.output)
  io.output(opts.output)
end

local fmt = "%6d%6d%6d\n"
io.write(("%6s%6s%6s\n"):format("x", "y", "z"))
for i=1,#locs do 
  io.write(fmt:format(locs[i].x, locs[i].y, locs[i].z))
end

io.flush()
