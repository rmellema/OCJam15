local component = require "component"
local fs        = require "filesystem"
local knn       = require "knn"
local shell     = require "shell"

local function printUsage()
  io.write("usage: smine [--depth=num] [--min=num] file valuables ...\n")
end

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

if not fs.exists(file) then
  io.write("smine: " .. file .. ": No such file or directory")
  return
end

local depth    = opts.depth or 15
local minFound = opts.min   or 3

print("Geolyzer found")
print("Prototypes file is: ", file)
print("The search depth is: ", depth)
print("The minimum valuables is:", minFound)
print("The valuables are:")
for i=1,#args do
  print(args[i])
end
